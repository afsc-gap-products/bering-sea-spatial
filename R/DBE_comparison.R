library(sumfish)
library(here)

# Original DBE
racebase <- getRacebase(1988:2021,'EBS_SHELF')
baseline <- sumStratum(racebase)
spp <- filter(racebase$species, SPECIES_CODE %in% c(21720,21740,10210,10261) )

# Visually verified produces same biomass (with rounding differences) as \\akc0ss-n086\AKC_Public\Dropbox\Haehn\SURVEY_ESTIMATES\2021\EBS\biomass
cod_baseline <- filter(baseline, speciesCode==21720, stratum=='TOTAL')
spp_baseline <- filter(baseline, speciesCode %in% spp$SPECIES_CODE)

# Import new strata files
EBS_strata_Conner2022 <- read_csv( here::here("data", "EBS_strata_Conner2022.csv") ) %>%
  transmute(STRATUM = as.character(Stratum), STRATUM_AREA=Area_KM2)

new_stratum <- racebase$stratum %>%
  select(-STRATUM_AREA) %>%
  inner_join(EBS_strata_Conner2022, by = "STRATUM")

new_racebase <- racebase
new_racebase$stratum <- new_stratum

new_DBE <- sumStratum(new_racebase)
cod_new <- filter(new_DBE, speciesCode==21720, stratum=='TOTAL') %>%
  rename(new_biomass = bioEstimate)
spp_new <- filter(new_DBE, speciesCode %in% spp$SPECIES_CODE) %>%
  rename(new_biomass = bioEstimate)

# Compare baseline biomass to new DBE
cod_compare <- cod_baseline %>%
  inner_join(cod_new, by = c("year") ) %>%
  transmute(year = year,
            percent_diff = 100*(bioEstimate-new_biomass)/bioEstimate)

spp_compare <- spp_baseline %>%
  inner_join(spp_new, by = c("year", "speciesCode", "stratum") ) %>%
  transmute(year = year,
            speciesCode = speciesCode,
            stratum = stratum,
            percent_diff = 100*(bioEstimate-new_biomass)/bioEstimate)
write_csv(spp_compare, here::here("comparison","biomass_pct_diff.csv"))

spp_compare_long <- mutate(spp_baseline, strata_set='Current DBE') %>%
  bind_rows( mutate(spp_new, strata_set='Revised Shapefiles',
                    bioEstimate=new_biomass))

for (s in spp$SPECIES_CODE) {
  sp_compare <- filter(spp_compare_long, speciesCode==s)

  sp_plot <- ggplot(sp_compare, aes(color=strata_set, x=year, y=bioEstimate)) +
    geom_point(position= position_dodge(width=.9), size=.1) +
    labs(title = spp[spp$SPECIES_CODE==s,]$COMMON_NAME,
         y = "Biomass (t)",
         x = "Year"
    ) +
    facet_wrap(vars(stratum), scales="free") +
    theme_bw()
  print(sp_plot)
  ggsave(paste0(spp[spp$SPECIES_CODE==s,]$COMMON_NAME,"_biomass.pdf"))
}
