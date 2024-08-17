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

/* Attribute type */
proc contents data=bank_csv;
run;

/* Missing values - Numerical Variables*/
proc means data=bank_csv nmiss;
run;

/* Missing values - Categorical Variables*/
proc freq data=bank_csv;
   tables Job Marital Education Default Housing Loan Contact Month Poutcome Y / missing;
run;

/* Find max, min, mean and standard deviation of numerical attributes. */
proc means data=bank_csv n mean std min max;
run;

/* Find max, min, mean and standard deviation of categorical attributes */
data bank_data_numeric;
   set bank_csv;
   
   /* Transform categorical variables to numeric codes */
   if Job = 'admin.' then Job_num = 1;
   else if Job = 'blue-collar' then Job_num = 2;
   else if Job = 'entrepreneur' then Job_num = 3;
   else if Job = 'housemaid' then Job_num = 3;
   else if Job = 'management' then Job_num = 3;
   else if Job = 'retired' then Job_num = 3;
   else if Job = 'self-employed' then Job_num = 3;
   else if Job = 'services' then Job_num = 3;
   else if Job = 'student' then Job_num = 3;
   else if Job = 'technician' then Job_num = 3;
   else if Job = 'unemployed' then Job_num = 3;
   else if Job = 'unknown' then Job_num = 3;
   else Job_num = .; /* Handle missing or other cases */
   
   if Marital = 'married' then Marital_num = 1;
   else if Marital = 'single' then Marital_num = 2;
   else if Marital = 'divorced' then Marital_num = 3;
   else Marital_num = .; /* Handle missing or other cases */
   
   if Education = 'primary' then Education_num = 1;
   else if Education = 'secondary' then Education_num = 2;
   else if Education = 'tertiary' then Education_num = 3;
   else if Education = 'unknown' then Education_num = 4;
   else Education_num = .; /* Handle missing or other cases */
   
   if Default = 'yes' then Default_num = 1;
   else if Default = 'no' then Default_num = 0;
   else Default_num = .; /* Handle missing or other cases */
   
   if Housing = 'yes' then Housing_num = 1;
   else if Housing = 'no' then Housing_num = 0;
   else Housing_num = .; /* Handle missing or other cases */
   
   if Loan = 'yes' then Loan_num = 1;
   else if Loan = 'no' then Loan_num = 0;
   else Loan_num = .; /* Handle missing or other cases */
   
   if Contact = 'cellular' then Contact_num = 1;
   else if Contact = 'telephone' then Contact_num = 2;
   else if Contact = 'unkown' then Contact_num = 3;
   else Contact_num = .; /* Handle missing or other cases */
   
   if Month = 'jan' then Month_num = 1;
   else if Month = 'feb' then Month_num = 2;
   else if Month = 'mar' then Month_num = 3;
   else if Month = 'apr' then Month_num = 4;
   else if Month = 'may' then Month_num = 5;
   else if Month = 'jun' then Month_num = 6;
   else if Month = 'jul' then Month_num = 7;
   else if Month = 'aug' then Month_num = 8;
   else if Month = 'sep' then Month_num = 9;
   else if Month = 'oct' then Month_num = 10;
   else if Month = 'nov' then Month_num = 11;
   else if Month = 'dec' then Month_num = 12;
   else Month_num = .; /* Handle missing or other cases */
   
   if Poutcome = 'success' then Poutcome_num = 1;
   else if Poutcome = 'failure' then Poutcome_num = 2;
   else if Poutcome = 'other' then Poutcome_num = 3;
   else if Poutcome = 'unknown' then Poutcome_num = 4;
   else Poutcome_num = .; /* Handle missing or other cases */
   
   if Y = 'yes' then Y_num = 1;
   else if Y = 'no' then Y_num = 0;
   else Y_num = .; /* Handle missing or other cases */
run;
                 /* Use PROC MEANS to calculate statistics for the numeric codes */
proc means data=bank_data_numeric n mean std min max;
   var Job_num Marital_num Education_num Default_num Housing_num Loan_num Contact_num Month_num Poutcome_num Y_num;
run;




proc sgplot data=bank_csv;
    title 'Boxplot of Previous Contacts by Outcome of Previous Marketing Campaign';
    hbox Previous / category=Poutcome;
    xaxis label='Previous Contacts';
    yaxis label='Outcome of Previous Marketing Campaign';
run;

/* --------------------------------------------------------------------------------------- */

/* Outlier information for 'Duration' attribute */
proc univariate data=bank_csv;
    var Duration;
    id Duration;
    output out=outliers pctlpts=1 99 pctlpre=P_;
run;

	/* Showcase all the outliers for the 'Duration' attribute */
proc means data=bank_csv noprint;
    var duration;
    output out=summary Q1=Q1 Q3=Q3;
run;

	/* Identify outliers based on IQR method */
data outliers_iqr;
    set bank_csv;
    if _n_ = 1 then set summary;
    IQR = Q3 - Q1;
    LowerBound = Q1 - 1.5 * IQR;
    UpperBound = Q3 + 1.5 * IQR;
    if duration > UpperBound;
run;

	/* Print the identified outliers */
proc print data=outliers_iqr;
    title "Outliers in Duration Based on IQR Method";
run;

/* Outlier scatterplot for 'Duration' attribute */
proc sgplot data=bank_csv;
    title "Box Plot of Duration with Outliers";
    vbox duration;
run;

/*/////////////////////////////////////////////////////////////////////////////////////////*/

/* Calculate percentiles for 'Day' attribute */
proc univariate data=bank_csv;
    var Day;
    id Day;
    output out=outliers pctlpts=1 99 pctlpre=P_;
run;

/* Calculate Q1 and Q3 for 'Day' attribute */
proc means data=bank_csv noprint;
    var Day;
    output out=summary Q1=Q1 Q3=Q3;
run;

/* Identify outliers using IQR method */
data outliers_iqr;
    set bank_csv;
    if _n_ = 1 then set summary;
    IQR = Q3 - Q1;
    LowerBound = Q1 - 1.5 * IQR;
    UpperBound = Q3 + 1.5 * IQR;
    if Day > UpperBound or Day < LowerBound;
run;

/* Print the identified outliers */
proc print data=outliers_iqr;
    title "Outliers in Day Based on IQR Method";
run;

/* Generate box plot for 'Day' attribute */
proc sgplot data=bank_csv;
    title "Box Plot of Day with Outliers";
    vbox Day;
run;

/*/////////////////////////////////////////////////////////////////////////////////////*/

/* Calculate percentiles for 'Campaign' attribute */
proc univariate data=bank_csv;
    var Campaign;
    id Campaign;
    output out=outliers pctlpts=1 99 pctlpre=P_;
run;

/* Calculate Q1 and Q3 for 'Campaign' attribute */
proc means data=bank_csv noprint;
    var Campaign;
    output out=summary Q1=Q1 Q3=Q3;
run;

/* Identify outliers using IQR method */
data outliers_iqr;
    set bank_csv;
    if _n_ = 1 then set summary;
    IQR = Q3 - Q1;
    LowerBound = Q1 - 1.5 * IQR;
    UpperBound = Q3 + 1.5 * IQR;
    if Campaign > UpperBound or Campaign < LowerBound;
run;

/* Print the identified outliers */
proc print data=outliers_iqr;
    title "Outliers in Campaign Based on IQR Method";
run;

/* Generate box plot for 'Campaign' attribute */
proc sgplot data=bank_csv;
    title "Box Plot of Campaign with Outliers";
    vbox Campaign;
run;

/*////////////////////////////////////////////////////////////////////////////////////////*/
/* Generate frequency distribution for 'Poutcome' */
proc freq data=bank_csv;
    tables Poutcome / out=poutcome_freq;
run;

/* Print the frequency distribution */
proc print data=poutcome_freq;
    title "Frequency Distribution of Poutcome";
run;

/* Calculate mean and standard deviation of the frequencies */
proc means data=poutcome_freq noprint;
    var count;
    output out=poutcome_stats mean=mean_freq std=std_freq;
run;

/* Identify outliers based on frequencies */
data poutcome_outliers;
    set poutcome_freq;
    if _n_ = 1 then set poutcome_stats;
    if count > mean_freq + 2*std_freq or count < mean_freq - 2*std_freq;
run;

/* Print the identified outliers */
proc print data=poutcome_outliers;
    title "Outliers in Poutcome Based on Frequency Distribution";
run;

/*//////////////////////////////////////////////////////////////////////////////////////////*/
/* Generate frequency distribution for 'Month' */
proc freq data=bank_csv;
    tables Month / out=month_freq;
run;

/* Print the frequency distribution */
proc print data=month_freq;
    title "Frequency Distribution of Month";
run;

/* Calculate mean and standard deviation of the frequencies */
proc means data=month_freq noprint;
    var count;
    output out=month_stats mean=mean_freq std=std_freq;
run;

/* Identify outliers based on frequencies */
data month_outliers;
    set month_freq;
    if _n_ = 1 then set month_stats;
    if count > mean_freq + 2*std_freq or count < mean_freq - 2*std_freq;
run;

/* Print the identified outliers */
proc print data=month_outliers;
    title "Outliers in Month Based on Frequency Distribution";
run;

/*//////////////////////////////////////////////////////////////////////////////////////////*/
/* Generate frequency distribution for 'y' (subscribed) */
proc freq data=bank_csv;
    tables y / out=y_freq;
run;

/* Print the frequency distribution */
proc print data=y_freq;
    title "Frequency Distribution of Subscribed (y)";
run;

/* Calculate mean and standard deviation of the frequencies */
proc means data=y_freq noprint;
    var count;
    output out=y_stats mean=mean_freq std=std_freq;
run;

/* Identify outliers based on frequencies */
data y_outliers;
    set y_freq;
    if _n_ = 1 then set y_stats;
    if count > mean_freq + 2*std_freq or count < mean_freq - 2*std_freq;
run;

/* Print the identified outliers */
proc print data=y_outliers;
    title "Outliers in Subscribed (y) Based on Frequency Distribution";
run;

/*//////////////////////////////////////////////////////////////////////////////////*/
/* Outlier information for 'Previous' attribute */
proc univariate data=bank_csv;
    var Previous;
    id Previous;
    output out=outliers_prev pctlpts=1 99 pctlpre=P_;
run;

/* Showcase all the outliers for the 'Previous' attribute */
proc means data=bank_csv noprint;
    var Previous;
    output out=summary_prev Q1=Q1 Q3=Q3;
run;

/* Identify outliers based on IQR method */
data outliers_iqr_prev;
    set bank_csv;
    if _n_ = 1 then set summary_prev;
    IQR = Q3 - Q1;
    LowerBound = Q1 - 1.5 * IQR;
    UpperBound = Q3 + 1.5 * IQR;
    if Previous < LowerBound or Previous > UpperBound;
run;

/* Print the identified outliers */
proc print data=outliers_iqr_prev;
    title "Outliers in Previous Contacts Based on IQR Method";
run;

/* Box plot for 'Previous' attribute */
proc sgplot data=bank_csv;
    title "Box Plot of Previous Contacts with Outliers";
    vbox Previous;
run;

/*//////////////////////////////////////////////////////////////////////////////////*/
/* Outlier information for 'Pdays' attribute */
proc univariate data=bank_csv;
    var Pdays;
    id Pdays;
    output out=outliers_pdays pctlpts=1 99 pctlpre=P_;
run;

/* Showcase all the outliers for the 'Pdays' attribute */
proc means data=bank_csv noprint;
    var Pdays;
    output out=summary_pdays Q1=Q1 Q3=Q3;
run;

/* Identify outliers based on IQR method */
data outliers_iqr_pdays;
    set bank_csv;
    if _n_ = 1 then set summary_pdays;
    IQR = Q3 - Q1;
    LowerBound = Q1 - 1.5 * IQR;
    UpperBound = Q3 + 1.5 * IQR;
    if Pdays < LowerBound or Pdays > UpperBound;
run;

/* Print the identified outliers */
proc print data=outliers_iqr_pdays;
    title "Outliers in Pdays Based on IQR Method";
run;

/* Box plot for 'Pdays' attribute */
proc sgplot data=bank_csv;
    title "Box Plot of Pdays with Outliers";
    vbox Pdays;
run;



/* ------------------------------------------------------------------------------------------------------ */

/* Analyze whether age has influence on the class attribute */
/* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

/* Plot a histogram of the 'age' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'age' Attribute for Class 'yes'";
    histogram age / binwidth=1;
    xaxis label="Age";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

/* Plot a histogram of the 'age' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'age' Attribute for Class 'no'";
    histogram age / binwidth=1;
    xaxis label="Age";
    yaxis label="Frequency";
run;

/* T-test for comparing means of age between the two classes */
proc ttest data=bank_csv;
    class y;
    var age;
run;

/* ANOVA for Age by Subscription Status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model age = y; /* Test differences in Age by y */
    title "ANOVA for Age by Subscription Status (y)";
run;








/*//////////////////////////////////////////////////////////////////////////////////////////*/

/* Analyze whether day has influence on the class attribute */
    /* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

    /* Plot a histogram of the 'day' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'day' Attribute for Class 'yes'";
    histogram day / binwidth=1;
    xaxis label="Day of the Month";
    yaxis label="Frequency";
run;

    /* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

    /* Plot a histogram of the 'day' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'day' Attribute for Class 'no'";
    histogram day / binwidth=1;
    xaxis label="Day of the Month";
    yaxis label="Frequency";
run;

/* T-test for comparing means */
proc ttest data=bank_csv;
    class y;
    var day;
run;

/* ANOVA for Day by Subscription Status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model Day = y; /* Test differences in Day by y */
    title "ANOVA for Day by Subscription Status (y)";
run;

/*//////////////////////////////////////////////////////////////////////////////////////////*/
/* Analyze whether duration has influence on the class attribute */
    /* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

    /* Plot a histogram of the 'duration' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'duration' Attribute for Class 'yes'";
    histogram duration / binwidth=10;
    xaxis label="Duration of Last Contact (seconds)";
    yaxis label="Frequency";
run;

    /* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

    /* Plot a histogram of the 'duration' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'duration' Attribute for Class 'no'";
    histogram duration / binwidth=10;
    xaxis label="Duration of Last Contact (seconds)";
    yaxis label="Frequency";
run;

/* T-test for comparing means of 'duration' */
proc ttest data=bank_csv;
    class y;
    var duration;
run;

/* ANOVA for Duration by Subscription Status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model Duration = y; /* Test differences in Duration by y */
    title "ANOVA for Duration by Subscription Status (y)";
run;

/*//////////////////////////////////////////////////////////////////////////////////////////*/
/* Analyze whether campaign has influence on the class attribute */
/* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

/* Plot a histogram of the 'campaign' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'campaign' Attribute for Class 'yes'";
    histogram campaign / binwidth=1;
    xaxis label="Number of Contacts during Campaign";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

/* Plot a histogram of the 'campaign' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'campaign' Attribute for Class 'no'";
    histogram campaign / binwidth=1;
    xaxis label="Number of Contacts during Campaign";
    yaxis label="Frequency";
run;

/* T-test for comparing means of 'campaign' */
proc ttest data=bank_csv;
    class y;
    var campaign;
run;

/* ANOVA for Campaign by Subscription Status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model Campaign = y; /* Test differences in Campaign by y */
    title "ANOVA for Campaign by Subscription Status (y)";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Analyze whether previous contacts have influence on the class attribute */
/* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

/* Plot a histogram of the 'previous' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'previous' Attribute for Class 'yes'";
    histogram previous / binwidth=1;
    xaxis label="Number of Previous Contacts";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

/* Plot a histogram of the 'previous' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'previous' Attribute for Class 'no'";
    histogram previous / binwidth=1;
    xaxis label="Number of Previous Contacts";
    yaxis label="Frequency";
run;

/* T-test for comparing means of 'previous' */
proc ttest data=bank_csv;
    class y;
    var previous;
run;

/* ANOVA for Previous by Subscription Status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model Previous = y; /* Test differences in Previous by y */
    title "ANOVA for Previous by Subscription Status (y)";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Analyze whether pdays (Duration Since Last Contact) has influence on the class attribute */
/* Filter the dataset to include only observations where the class attribute is 'yes' */
data bank_csv_y_yes;
    set bank_csv;
    where y = 'yes';
run;

/* Plot a histogram of the 'pdays' attribute for the 'yes' class */
proc sgplot data=bank_csv_y_yes;
    title "Histogram of 'pdays' Attribute for Class 'yes'";
    histogram pdays / binwidth=10;
    xaxis label="Duration Since Last Contact (Days)";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the class attribute is 'no' */
data bank_csv_y_no;
    set bank_csv;
    where y = 'no';
run;

/* Plot a histogram of the 'pdays' attribute for the 'no' class */
proc sgplot data=bank_csv_y_no;
    title "Histogram of 'pdays' Attribute for Class 'no'";
    histogram pdays / binwidth=10;
    xaxis label="Duration Since Last Contact (Days)";
    yaxis label="Frequency";
run;

/* T-test for comparing means of 'pdays' */
proc ttest data=bank_csv;
    class y;
    var pdays;
run;


/* Perform ANOVA to test for differences in pdays by subscription status (y) */
proc glm data=bank_csv;
    class y; /* Subscription status is the categorical variable */
    model pdays = y; /* Test differences in pdays by y */
    title "ANOVA for pdays by Subscription Status (y)";
run;

/* ------------------------------------------------------------------------------------------------------ */
*/Which attributes seem to be correlated? Which attributes seem to be most linked to the class attribute?/*

proc corr data=bank_csv nosimple;
    var day duration campaign;
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Contingency Table for Job and Subscribed */
proc freq data=bank_csv;
    tables job*y / chisq;
    title "Contingency Table for Job and Subscription Status";
run;

/* Chi-Square Test for Job and Subscribed */
proc freq data=bank_csv;
    tables job*y / chisq expected;
    title "Chi-Square Test for Job and Subscription Status";
run;








/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Contingency Table for Month and Poutcome */
proc freq data=bank_csv;
    tables Month*Poutcome / chisq;
    title "Contingency Table for Month and Poutcome";
run;

/* Chi-Square Test for Month and Poutcome */
proc freq data=bank_csv;
    tables Month*Poutcome / chisq expected;
    title "Chi-Square Test for Month and Poutcome";
run;


/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Chi-square test for Month vs. Subscribed */
proc freq data=bank_csv;
    tables Month*y / chisq;
run;

/* Contingency table for Month vs. Subscribed */
proc freq data=bank_csv;
    tables Month*y / chisq;
run;


/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Chi-square test for Poutcome vs. Subscribed */
proc freq data=bank_csv;
    tables Poutcome*y / chisq;
run;

/* Contingency table for Poutcome vs. Subscribed */
proc freq data=bank_csv;
    tables Poutcome*y / chisq;
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/*Below is categorical vs numerical analysis*/
/* Step 1: Visualize the distribution of Campaign across Month */
proc sgplot data=bank_csv;
    title "Box Plot of Campaign by Month";
    vbox Campaign / category=Month;
run;

/* Step 2: Perform ANOVA to test for differences */
proc glm data=bank_csv;
    class Month;
    model Campaign = Month;
    title "ANOVA for Campaign by Month";
run;

/* Step 3: Perform Kruskal-Wallis test as alternative (if assumptions are not met) */
proc npar1way data=bank_csv wilcoxon;
    class Month;
    var Campaign;
    title "Kruskal-Wallis Test for Campaign by Month";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Day by Month";
    vbox day / category=Month;
run;


proc glm data=bank_csv;
    class Month;
    model day = Month;
    title "ANOVA for Day by Month";
run;

proc npar1way data=bank_csv wilcoxon;
    class Month;
    var day;
    title "Kruskal-Wallis Test for Day by Month";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Duration by Month";
    vbox Duration / category=Month;
run;

proc glm data=bank_csv;
    class Month;
    model Duration = Month;
    title "ANOVA for Duration by Month";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Day by Poutcome";
    vbox day / category=Poutcome;
run;

proc glm data=bank_csv;
    class Poutcome;
    model day = Poutcome;
    title "ANOVA for Day by Poutcome";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Duration by Poutcome";
    vbox duration / category=Poutcome;
run;

proc glm data=bank_csv;
    class Poutcome;
    model duration = Poutcome;
    title "ANOVA for Duration by Poutcome";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Campaign by Poutcome";
    vbox campaign / category=Poutcome;
run;

proc glm data=bank_csv;
    class Poutcome;
    model campaign = Poutcome;
    title "ANOVA for Campaign by Poutcome";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc corr data=bank_csv nosimple;
    var previous pdays;
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

proc sgplot data=bank_csv;
    title "Box Plot of Previous by Poutcome";
    vbox Previous / category=Poutcome;
run;

proc glm data=bank_csv;
    class Poutcome;
    model Previous = Poutcome;
    title "ANOVA for Previous by Poutcome";
run;

/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

/* Box Plot of Pdays by Poutcome */
proc sgplot data=bank_csv;
    title "Box Plot of Pdays by Poutcome";
    vbox pdays / category=Poutcome;
run;

/* ANOVA for Pdays by Poutcome */
proc glm data=bank_csv;
    class Poutcome;
    model pdays = Poutcome;
    title "ANOVA for Pdays by Poutcome";
run;

/* ------------------------------------------------------------------------------------------------------ */
/*Determine whether the dataset has an imbalanced class distribution (same proportion of records of different types or not) and do you need to balance the dataset.*/

/* Count the number of records for each class */
proc freq data=bank_csv;
    tables y / nocum nopercent;
    title "Class Distribution of Subscribed";
run;

/* Visualize class distribution */
proc sgplot data=bank_csv;
    vbar y / datalabel;
    title "Class Distribution of Subscribed";
run;

