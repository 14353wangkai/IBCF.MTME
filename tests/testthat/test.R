library(testthat)
library(IBCF.MTME)

context('Data transformation tests')

test_that('getMatrixForm and getTidyForm functions', {
  data('Wheat_IBCF')
  data('Year_IBCF')

  M <- getMatrixForm(Wheat_IBCF)
  Tidy <- getTidyForm(M)

  M.Y <- getMatrixForm(Year_IBCF, onlyTrait = T)
  Tidy.Y <- getTidyForm(M.Y, onlyTrait = T)

  expect_output(str(M), '250 obs. of  13 variables')
  expect_output(str(M.Y), '60 obs. of  14 variables')

  expect_output(str(Tidy), '3000 obs. of  4 variables')
  expect_output(str(Tidy.Y), '720 obs. of  4 variables')
})

context('CV.RandomPart Tests')

test_that('Crossvalidation.RP function', {
  data('Wheat_IBCF')
  CrossV1 <- CV.RandomPart(Wheat_IBCF, Set_seed = 123)
  CrossV2 <- CV.RandomPart(Wheat_IBCF, NPartitions = 10, Set_seed = 123)
  CrossV3 <- CV.RandomPart(Wheat_IBCF, NPartitions = 10, PTesting = 0.35, Set_seed = 123)

  expect_equal(CrossV1, CrossV2)
  expect_equal(CrossV1, CrossV3)

  expect_output(str(CrossV1), 'List of 6')
  expect_is(CrossV1, 'CrossValidation')

  expect_output(str(CrossV1$DataSet), '250 obs. of  13 variables')
  expect_false(any(is.na(CrossV1$DataSet)))

  expect_false(any(is.na(CrossV1$CrossValidation_list)))
  expect_output(str(CrossV1$CrossValidation_list), 'List of 10')

  expect_length(CrossV1$Environments, 3)
  expect_is(CrossV1$Environments, 'character')

  expect_length(CrossV1$Traits, 4)
  expect_is(CrossV1$Traits, 'character')

  expect_output(str(CrossV1$Observations), 'int 250')
  expect_is(CrossV1$Observations, 'integer')
})

context('IBCF Test - With RPartition')
test_that('IBCF Test - With RP for 3 Envs, 4 Traits', {
  data('Wheat_IBCF')
  CrossV <- CV.RandomPart(Wheat_IBCF, NPartitions = 10, PTesting = 0.25, Set_seed = 123)
  pm <- IBCF(CrossV)

  expect_is(pm, 'IBCF')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$NPartitions, 'integer')
  expect_length(pm$NPartitions, 1)

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'character')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted_Partition)))
  expect_output(str(pm$predicted_Partition), 'List of 10')

  expect_false(any(is.null(pm$observed)))
  expect_length(pm$yHat, length(pm$observed))
})


test_that('IBCF Test - With RP for 3 Envs selecting 2 envs for traits', {
  data('Wheat_IBCF')
  CrossV <- CV.RandomPart(Wheat_IBCF,Traits.testing = c('DH', 'GY'), NPartitions = 10, PTesting = 0.25, Set_seed = 123)
  pm <- IBCF(CrossV)

  expect_is(pm, 'IBCF')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$NPartitions, 'integer')
  expect_length(pm$NPartitions, 1)

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'character')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted_Partition)))
  expect_output(str(pm$predicted_Partition), 'List of 10')

  expect_false(any(is.null(pm$observed)))
  expect_length(pm$yHat, length(pm$observed))
})


test_that('IBCF Test - With RP for 3 Envs without Traits', {
  data('Wheat_IBCF')
  data <- Wheat_IBCF[which(Wheat_IBCF$Trait == 'DH'), ]
  data <- data[,c(1,3,4)]

  CrossV <- CV.RandomPart(data, NPartitions = 10, PTesting = 0.25, Set_seed = 123)
  pm <- IBCF(CrossV)


  expect_is(pm, 'IBCF')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$NPartitions, 'integer')
  expect_length(pm$NPartitions, 1)

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'character')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted_Partition)))
  expect_output(str(pm$predicted_Partition), 'List of 10')

  expect_false(any(is.null(pm$observed)))
  expect_length(pm$yHat, length(pm$observed))
})

test_that('IBCF Test - With RP for 4 Traits without Env', {
  data('Wheat_IBCF')
  data <- Wheat_IBCF[which(Wheat_IBCF$Env == 'Bed5IR'), ]
  data <- data[,c(1,2,4)]

  CrossV <- CV.RandomPart(data, NPartitions = 10, PTesting = 0.25, Set_seed = 123)
  pm <- IBCF(CrossV)

  expect_is(pm, 'IBCF')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$NPartitions, 'integer')
  expect_length(pm$NPartitions, 1)

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'character')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted_Partition)))
  expect_output(str(pm$predicted_Partition), 'List of 10')

  expect_false(any(is.null(pm$observed)))
  expect_length(pm$yHat, length(pm$observed))
})

context('IBCFY Tests')
test_that('IBCFY function', {
  data('Year_IBCF')
  DataSet <- getMatrixForm(Year_IBCF, onlyTrait = T)

  pm <- IBCF.Years(DataSet, colYears = 'Years' , Years.testing = c('2015', '2016'), Traits.testing = c('T5', 'T6'))

  expect_is(pm, 'IBCFY')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$Years.testing, 'character')
  expect_is(pm$Traits.testing, 'character')

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'factor')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted)))
  expect_false(any(is.null(pm$observed)))
  expect_length(pm$predicted, length(pm$observed))
})

test_that('IBCFY function one Trait for test', {
  data('Year_IBCF')
  DataSet <- getMatrixForm(Year_IBCF, onlyTrait = T)

  pm <- IBCF.Years(DataSet , Years.testing = c('2015', '2016'), Traits.testing = c('T5'))

  expect_is(pm, 'IBCFY')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$Years.testing, 'character')
  expect_is(pm$Traits.testing, 'character')

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'factor')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted)))
  expect_false(any(is.null(pm$observed)))
  expect_length(pm$predicted, length(pm$observed))
})

test_that('IBCFY function for one year and one trait', {
  data('Year_IBCF')
  DataSet <- getMatrixForm(Year_IBCF, onlyTrait = T)

  pm <- IBCF.Years(DataSet , Years.testing = c('2015'), Traits.testing = c('T5'))

  expect_is(pm, 'IBCFY')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$Years.testing, 'character')
  expect_is(pm$Traits.testing, 'character')

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'factor')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted)))
  expect_false(any(is.null(pm$observed)))
  expect_length(pm$predicted, length(pm$observed))
})

test_that('IBCFY function with Wheat_IBCF Training', {
  data('Wheat_IBCF')

  DataSet <- getMatrixForm(Wheat_IBCF, onlyTrait = T)
  pm <- IBCF.Years(DataSet, colYears = "Env", Years.testing = 'Drip', Traits.testing = c('DH','GY'))

  expect_is(pm, 'IBCFY')
  expect_output(str(pm), 'List of 6')

  expect_is(pm$Years.testing, 'character')
  expect_is(pm$Traits.testing, 'character')

  expect_false(any(is.na(pm$predictions_Summary)))
  expect_is(pm$predictions_Summary, 'data.frame')
  expect_is(pm$predictions_Summary[1, 1], 'factor')
  expect_is(pm$predictions_Summary[1, 2], 'numeric')
  expect_equal(pm$predictions_Summary, summary(pm))

  expect_false(any(is.null(pm$predicted)))
  expect_false(any(is.null(pm$observed)))
  expect_length(pm$predicted, length(pm$observed))
})
