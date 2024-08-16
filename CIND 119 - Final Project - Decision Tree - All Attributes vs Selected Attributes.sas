/* 1.Read the file in SAS and display the contents using the PROC IMPORT and PROC PRINT procedures*/
proc import
/* out keyword is used to name a table*/
out=bank_csv
/* Datafile keyword takes the path of the file from the hard disk*/
datafile ="/home/u63872294/Data/bank.csv"
/* “dbms= csv replace” is telling SAS it is a csv file. */
dbms=csv replace;
/* “Getnames=yes” will use first line of the csv file as column names*/
getnames=yes;
/*Data keyword takes the name of the SAS table imported as heart_csv. Print keyword outputs the contents in Results Viewer */
proc print data=bank_csv (obs=100);
/* using contents procedure to check metadata*/
proc contents data=bank_csv;
/* run keyword will execute the above code lines*/
run;


/* ALL ATTRIBUTES*/
/* Step 1: Load the dataset */
proc import datafile="/home/u63872294/Data/bank.csv"
    out=ORIGINAL_DATA
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Check the class distribution */
proc freq data=ORIGINAL_DATA;
    tables y / out=ClassDist;
run;

/* Step 3: Oversample the minority class ('yes') to balance the dataset */
/* First, separate the minority and majority classes */
data Minority Majority;
    set ORIGINAL_DATA;
    if y = 'yes' then output Minority;
    else if y = 'no' then output Majority;
run;

/* Determine the replication factor for oversampling */
proc sql noprint;
    select count(*) into :n_majority from Majority;
    select count(*) into :n_minority from Minority;
quit;

/* Calculate the number of replications needed */
%let rep_factor = %sysevalf((&n_majority / &n_minority), ceil);

/* Perform oversampling on the minority class */
data Minority_Oversampled;
    set Minority;
    do i = 1 to &rep_factor;
        output;
    end;
run;

/* Combine the oversampled minority class with the original majority class */
data BalancedData;
    set Minority_Oversampled Majority;
run;

/* Step 4: Check the new class distribution */
proc freq data=BalancedData;
    tables y;
run;

/* Step 5: Sort the balanced dataset by the stratification variable */
proc sort data=BalancedData;
    by y;
run;

/* Step 6: Split the balanced dataset into training (70%) and testing (30%) */
proc surveyselect data=BalancedData
    out=TrainData
    samprate=0.7
    seed=12345
    outall;
    strata y;
run;

data TrainData TestData;
    set TrainData;
    if selected then output TrainData;
    else output TestData;
run;

/* Step 7: Create a decision tree */
proc hpsplit data=TrainData maxdepth=10;
    class y age job marital education default balance housing loan contact day month duration campaign pdays previous poutcome;
    model y = age job marital education default balance housing loan contact day month duration campaign pdays previous poutcome;
    grow gini;
    prune entropy;
    code file='/home/u63872294/Data/decision_tree_score.sas';
run;

/* Step 8: Score the test dataset */
data ScoredData;
    set TestData;
    %include '/home/u63872294/Data/decision_tree_score.sas';
    /* Assuming P_yyes is the probability of y being 'yes', set a threshold, e.g., 0.5 */
    if P_yyes >= 0.5103 then Predicted_y = 'yes';
    else Predicted_y = 'no';
run;

/* Step 9: Evaluate the performance */
proc freq data=ScoredData;
    tables y*Predicted_y / norow nocol nopercent chisq;
run;

/* Check the contents of ScoredData to ensure P_yyes exists */
proc contents data=ScoredData;
run;

/* Create confusion matrix and performance metrics */
proc sql;
    create table ConfMatrix as
    select
        sum(case when y='yes' and Predicted_y='yes' then 1 else 0 end) as TP,
        sum(case when y='yes' and Predicted_y='no' then 1 else 0 end) as FN,
        sum(case when y='no' and Predicted_y='yes' then 1 else 0 end) as FP,
        sum(case when y='no' and Predicted_y='no' then 1 else 0 end) as TN
    from ScoredData;
quit;

proc print data=ConfMatrix;
run;

data Metrics;
    set ConfMatrix;
    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    TPR = TP / (TP + FN); /* Sensitivity or Recall */
    FPR = FP / (FP + TN); /* Fall-out or False Positive Rate */
    Specificity = TN / (TN + FP); /* Specificity or True Negative Rate */
    Precision = TP / (TP + FP); /* Precision */
    F_Measure = 2 * ((Precision * TPR) / (Precision + TPR)); /* F-measure (F1 score) */
    keep Accuracy TPR FPR Specificity Precision F_Measure;
run;

proc print data=Metrics;
run;




/*SELECTED ATTRIBUTES*/
/* Step 1: Load the dataset */
proc import datafile="/home/u63872294/Data/bank.csv"
    out=ORIGINAL_DATA
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Check the class distribution */
proc freq data=ORIGINAL_DATA;
    tables y / out=ClassDist;
run;

/* Step 3: Oversample the minority class ('yes') to balance the dataset */
/* First, separate the minority and majority classes */
data Minority Majority;
    set ORIGINAL_DATA;
    if y = 'yes' then output Minority;
    else if y = 'no' then output Majority;
run;

/* Determine the replication factor for oversampling */
proc sql noprint;
    select count(*) into :n_majority from Majority;
    select count(*) into :n_minority from Minority;
quit;

/* Calculate the number of replications needed */
%let rep_factor = %sysevalf((&n_majority / &n_minority), ceil);

/* Perform oversampling on the minority class */
data Minority_Oversampled;
    set Minority;
    do i = 1 to &rep_factor;
        output;
    end;
run;

/* Combine the oversampled minority class with the original majority class */
data BalancedData;
    set Minority_Oversampled Majority;
run;

/* Step 4: Check the new class distribution */
proc freq data=BalancedData;
    tables y;
run;

/* Step 5: Sort the balanced dataset by the stratification variable */
proc sort data=BalancedData;
    by y;
run;

/* Step 6: Split the balanced dataset into training (70%) and testing (30%) */
proc surveyselect data=BalancedData
    out=TrainData
    samprate=0.7
    seed=12345
    outall;
    strata y;
run;

data TrainData TestData;
    set TrainData;
    if selected then output TrainData;
    else output TestData;
run;

/* Step 7: Create a decision tree */
proc hpsplit data=TrainData maxdepth=11;         /*max depth was 10, now 11*/
    class y poutcome pdays month job duration age day;
    model y = poutcome pdays month job duration age day;
    grow gini;
    prune entropy;
    code file='/home/u63872294/Data/decision_tree_score.sas';
run;

/* Step 8: Score the test dataset */
data ScoredData;
    set TestData;
    %include '/home/u63872294/Data/decision_tree_score.sas';
    /* Assuming P_yyes is the probability of y being 'yes', set a threshold, e.g., 0.5 */
    if P_yyes >= 0.5 then Predicted_y = 'yes';
    else Predicted_y = 'no';
run;

/* Step 9: Evaluate the performance */
proc freq data=ScoredData;
    tables y*Predicted_y / norow nocol nopercent chisq;
run;

proc contents data=ScoredData;
run;

proc sql;
    create table ConfMatrix as
    select
        sum(case when y='yes' and Predicted_y='yes' then 1 else 0 end) as TP,
        sum(case when y='yes' and Predicted_y='no' then 1 else 0 end) as FN,
        sum(case when y='no' and Predicted_y='yes' then 1 else 0 end) as FP,
        sum(case when y='no' and Predicted_y='no' then 1 else 0 end) as TN
    from ScoredData;
quit;

proc print data=ConfMatrix;
run;

data Metrics;
    set ConfMatrix;
    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    TPR = TP / (TP + FN); /* Sensitivity or Recall */
    FPR = FP / (FP + TN); /* Fall-out or False Positive Rate */
    Specificity = TN / (TN + FP); /* Specificity or True Negative Rate */
    Precision = TP / (TP + FP); /* Precision */
    F_Measure = 2 * ((Precision * TPR) / (Precision + TPR)); /* F-measure (F1 score) */
    keep Accuracy TPR FPR Specificity Precision F_Measure;
run;

proc print data=Metrics;
run;
