double calculateVolumePerDose(double powderAmount, double solventVolume, double desiredConcentration) {
  if (desiredConcentration == 0) return 0;
  return solventVolume / (powderAmount / desiredConcentration);
}