# PSU_Stat_184: Introduction to Data Wrangling in R: Importing, Reshaping, Visualizing Data

## Course Information
### Teaching Team
Dr. Drew Wham 
Office: 22c Sheilds Building
email: fcw5014 [at] psu [dot] edu

Office Hours (22c Sheilds Building):
* Monday 10-11
* Friday 11-12
* By appointment

Jeffrey Yan
email: jyan2 [at] alumni [dot] cmu [dot] edu

### Class Time & Location
Time/Day: Wednesdays and Fridays from 10:10am - 11:00am 
Location: 101 Althouse Lab

### Laptops 
Laptops: Bring a laptop to class each day if you have one. I encourage students to work collaboratively, so I’d like to have at least one laptop for every 2 or 3 students.

## Resources
### Textbooks

[Data Computing](https://www.amazon.com/Data-Computing-Introduction-Wrangling-Visualization/dp/0983965846/ref=sr_1_1?ie=UTF8&qid=1534936861&sr=8-1&keywords=Data+Computing): An Introduction to Wrangling and Visualisation with R by Daniel Kaplan

[R for Data Science](http://r4ds.had.co.nz/index.html) by Hadley Wickham & Garret Grolemund

[Advanced R](https://link.springer.com/book/10.1007/978-1-4842-2077-1) by Matt Wiley and Joshua Wiley

### Package Cheatsheets
* [datatables](https://github.com/Rdatatable/data.table/wiki/Getting-started)([cheatsheet](http://datacamp-community.s3.amazonaws.com/6fdf799f-76ba-45b1-b8d8-39c4d4211c31))([cheatsheet2](https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf))
* [dplyr](http://dplyr.tidyverse.org)([cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf))
* [reshape2](https://cran.r-project.org/web/packages/reshape2/reshape2.pdf)([cheatsheet](http://rstudio-pubs-static.s3.amazonaws.com/14391_c58a54d88eac4dfbb80d8e07bcf92194.html))
* [ggplot2 - Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf)
* [stringr - Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/strings.pdf)
* [lubridate - Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/lubridate.pdf)

### Software
Follow the below links download and install the appropriate version of R, R Studio and Atom for your operating system
* [R](https://www.r-project.org)
* [RStudio](https://www.rstudio.com/products/RStudio/)
* [Atom](https://atom.io)

## Communication
### Piazza

We will be using Piazza for class-related discussion and questions, to help you benefit from each other’s questions and the collective knowledge of your classmates and professor. Questions can be posted to the entire class (for content-related questions). I encourage you to ask questions if you are struggling to understand a concept, and to answer your classmates’ questions when you can. Note that you may choose to post questions or comments to Piazza anonymously if you wish. Piazza may also be used for course announcements.

Do Not use Piazza for issues related to your grade or other private matters (not even an instructor post); email those questions or comments to the instructor directly or discuss them in person.

### Email

Most issues about classroom activities can be posted to Piazza, but you should use email (or a conversation in person) for all personal or private matters.

### Grading
Learning outcomes will be assessed based on performance in each of the following categories accompanied by their impact on the overall grade:

* 20% Weekly Activities
* 15% Semester Project
* 30% Exams (Midterm + Final)
* 15% Exercises
* 10% Reading Quizzes
* 10% Participation

Final letter grades will be determined as follows:
* A : 93-100%
* A-: 90-92%
* B+: 87-89%
* B : 83-86%
* B-: 80-82%
* C+: 77-79%
* C : 70-76%
* D : 60-69%
* F : < 60%

### Semester Project

The final project provides an opportunity to combine content learned throughout the course for use in some realistic application. Each student is required to individually complete and sumbit their own work, but students consult one another with questions (post questions on Piazza, chat with group members, etc). A successful project will find one or more real & interesting data sets, and use their R programming skills to tell a story that reveals insights from the data. The weekly group activities in the Data Computing text book are good examples of the type of work expected for a successful project, with the differences that you are expected to do the work independently using your own data (not loaded from an R package), and you are responsible for the narrative explaining your reasoning and conclusions as you work through the analysis.

### In-Class Assignments

Weekly in-class assignments may include an activity or a quiz assigned and completed in part or whole during class. The format and length of in-class assignments will vary as warranted by the subject matter each week, although each assignments will be given the same weight toward the overall grade. There are no make-up assignments, although the lowest score will be dropped at the end of the semester.

### Reading Quizzes

Weekly reading quizzes will be due before class in order to assess comprehension of the reading assignment that will be discussed each week. This allows students to see new content and concepts for the first time at their own pace in order to more effectively use class time to emphasize main points, clear up confusion, etc. The goal of the reading quiz is to hold students accountable for completing the reading each week before class.

### Participation

Participation is graded based on Piazza participation and attendance. In order to earn full credit for the Piazza portion, each student should make 2 or more substantive posts per week related to the content of the course; at least one post each week should be a reply to another student’s post. You may still post anonymously if you wish; grading will utilize Piazza meta-data that can be accessed only by an instructor.

Since our class only meets once each week, attendance is very important. Moreover, students will be encouraged to work in teams on in-class assignments, so others are counting on you to be in class each week. Students with University excused absences (e.g. athletics) should notify the instructor as soon as possible and provide a minimum of one week notice.

### Homework

Weekly homework assignments will be due before class in order to assess understanding and content mastery. Students are encouraged to work together on homework assignments, but each student must hand in their own work. Late homework is accepted for one week after the original due date and scored using a 50% penalty.

## Course Description and Objectives
### Description

The official course description is available in Penn State’s University Bulletin [linked here](http://undergraduate.bulletins.psu.edu/search/?scontext=courses&search=stat+184), but a recent version is reproduced below for your convenience.

STAT 184 Introduction to R: R is a powerful, open-source programming language used widely for statistical analyses. It is easily extendible, and thousands of user-created packages are publicly available to extend its capabilities. This course will introduce R syntax: Students will be asked to utilize various descriptive and graphical statistical techniques for various types of datasets. These datasets will primarily be drawn from those that are readily available for R; emphasis will not be on obtaining nor cleaning raw data in this course. Furthermore, this course focus on descriptive statistics and graphical summary techniques rather than inferential statistical techniques. In particular, no statistical background will be assumed. In addition to being asked to write well-documented code for functions in R, students will be exposed to development environments (e.g., the open-source RStudio environment) and the Shiny framework for web applications.

### Goals and objectives

Some goals and objectives may be reduced or expanded as time permits, but a tentative list follows:

#### General Tools
* Become familiar with R programming language
* Become familiar with RStudio development environment
* Generate reproducible work 
* Navigate some basic syntax and idioms in R
#### Programming style
* Naming variables
* Using functions
* Installing and using contributed packages
#### Read & write data files using R
#### Data wrangling using R
* “Tidy Data”
* data.table and dplyr package
#### Generate descriptive statistics using R
#### Graphs & Data Visualization
* ggplot2 graphics

## Policies & Resources
### Working collaboratively
All quizes and tests must be done individualy without the aid of other students, however many assighnments and in-class activities will be done in groups. Whenever solutions or code is developed in teams the names of all authors should appear on the author line, even when code is submitted individualy. In these cases the principle authors name should appear first followed by all collaborating team members. For this reason, a single persons name may appear on multiple assignments. Turning in an assighnment with an author line that does not reflect the origins of the work is a violation of academic integrity. 

### ECoS Code of Mutual Respect
The Eberly College of Science [Code of Mutual Respect and Cooperation](http://science.psu.edu/climate/support-and-resources/code-of-mutual-respect-and-cooperation-pdf) embodies the values that we hope our faculty, staff, and students possess and will endorse to make the Eberly College of Science a place where every individual feels respected and valued, as well as challenged and rewarded.

### Academic Integrity Statement
Academic dishonesty is not limited to simply cheating on an exam or assignment. The following is quoted directly from the “PSU Faculty Senate Policies for Students” regarding academic integrity and academic dishonesty:

Academic integrity is the pursuit of scholarly activity free from fraud and deception and is an educational objective of this institution. Academic dishonesty includes, but is not limited to, cheating, plagiarizing, fabricating of information or citations, facilitating acts of academic dishonesty by others, having unauthorized possession of examinations, submitting work of another person or work previously used without informing the instructor, or tampering with the academic work of other students.
All University and Eberly College of Science policies regarding academic integrity/academic dishonesty apply to this course and the students enrolled in this course. Refer to the following URL for further details on the academic integrity policies of the Eberly College of Science: http://www.science.psu.edu/academic/Integrity/index.html. Each student in this course is expected to work entirely on her/his own while taking any exam, to complete assignments on her/his own effort without the assistance of others unless directed otherwise by the instructor, and to abide by University and Eberly College of Science policies about academic integrity and academic dishonesty. Academic dishonesty can result in assignment of “F” by the course instructors or “XF” by Judicial Affairs as the final grade for the student.

### Disability Policy
Penn State welcomes students with disabilities into the University’s educational programs. If you have a disability-related need for reasonable academic adjustments in this course, contact Student Disability Resources (SDR; formerly ODS) at 814-863-1807, 116 Boucke, http://equity.psu.edu/student-disability-resources. In order to receive consideration for course accommodations, you must contact ODS and provide documentation (see the guidelines at http://equity.psu.edu/student-disability-resources/guidelines).




