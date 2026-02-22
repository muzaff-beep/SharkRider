#!/usr/bin/env bash
# DriverHarvest / Shark Rider – initial folder + file skeleton
# Run this in Codespaces / Termux / any bash environment

set -euo pipefail

echo "Creating project skeleton..."

mkdir -p \
  app/src/main/{kotlin/com/driverharvest/app,res/values} \
  core/src/main/kotlin/com/driverharvest/core/{utils,di} \
  data/src/main/kotlin/com/driverharvest/data/{db,entity} \
  domain/src/main/kotlin/com/driverharvest/domain/{repository,usecase} \
  feature/capture/src/main/{kotlin/com/driverharvest/feature/capture,res/xml} \
  feature/rating/src/main/kotlin/com/driverharvest/feature/rating \
  feature/proof/src/main/kotlin/com/driverharvest/feature/proof \
  feature/export/src/main/kotlin/com/driverharvest/feature/export \
  feature/ui-common/src/main/kotlin/com/driverharvest/feature/ui_common/{theme,components}

touch \
  app/src/main/kotlin/com/driverharvest/app/{MainActivity.kt,AppNavGraph.kt,OnboardingScreen.kt,AppTheme.kt,HiltApp.kt} \
  app/src/main/res/values/strings.xml \
  app/src/main/AndroidManifest.xml \
  app/build.gradle.kts \
  \
  core/src/main/kotlin/com/driverharvest/core/utils/{HashUtils.kt,NormalizationUtils.kt} \
  core/src/main/kotlin/com/driverharvest/core/di/CoreModule.kt \
  core/build.gradle.kts \
  \
  data/src/main/kotlin/com/driverharvest/data/db/{AppDatabase.kt,RideDao.kt} \
  data/src/main/kotlin/com/driverharvest/data/entity/RideEntity.kt \
  data/build.gradle.kts \
  \
  domain/src/main/kotlin/com/driverharvest/domain/repository/RideRepository.kt \
  domain/src/main/kotlin/com/driverharvest/domain/usecase/GetPassengerScoreUseCase.kt \
  domain/build.gradle.kts \
  \
  feature/capture/src/main/kotlin/com/driverharvest/feature/capture/RideLoggerService.kt \
  feature/capture/res/xml/accessibility_service_config.xml \
  feature/capture/build.gradle.kts \
  \
  feature/rating/src/main/kotlin/com/driverharvest/feature/rating/{RatingPopupScreen.kt,ScoreCalculator.kt,WarningPopup.kt} \
  feature/rating/build.gradle.kts \
  \
  feature/proof/src/main/kotlin/com/driverharvest/feature/proof/{UsbCameraManager.kt,ProofRecorder.kt} \
  feature/proof/build.gradle.kts \
  \
  feature/export/src/main/kotlin/com/driverharvest/feature/export/{ExportUtils.kt,ShareHelper.kt} \
  feature/export/build.gradle.kts \
  \
  feature/ui-common/src/main/kotlin/com/driverharvest/feature/ui_common/theme/Theme.kt \
  feature/ui-common/src/main/kotlin/com/driverharvest/feature/ui_common/components/RideBadge.kt \
  feature/ui-common/build.gradle.kts \
  \
  build.gradle.kts \
  settings.gradle.kts \
  gradle.properties \
  

echo "Skeleton created."
echo "Next: populate build.gradle.kts files and add initial content to key classes."
echo "Run 'ls -R' to verify structure."