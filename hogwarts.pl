%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the students in Hogwarts %%%%%%%% student(SID,SN,House)
student(hp, 'Harry James Potter', gryffindor).
student(hg, 'Hermione Jean Granger', gryffindor).
student(rw, 'Ronald Weasley', gryffindor).
student(ll, 'Luna Lovegood', ravenclaw).
student(cc, 'Cho Chang', ravenclaw).
student(tb, 'Terry Boot', ravenclaw).
student(ha, 'Hannah Abbott', hufflepuff).
student(cd, 'Cedric Diggory', hufflepuff).
student(nt, 'Nymphadora Tonks',hufflepuff).
student(dm, 'Draco Malfoy', slytherin).
student(gg, 'Gregory Goyle', slytherin).
student(vc, 'Vincent Crabbe', slytherin).
student(yd, 'Ying Deng', slytherin).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the teachers in Hogwarts %%%%%%% teacher(TID,TN)
teacher(ad, 'Albus Percival Wulfric Brian Dumbledore').
teacher(ff, 'Filius Flitwick').
teacher(rh, 'Rubeus Hagrid').
teacher(gl, 'Gilderoy Lockhart').
teacher(rl, 'Remus John Lupin').
teacher(mm, 'Minerva McGonagall').
teacher(qq, 'Quirinus Quirrell').
teacher(ss, 'Severus Snape').
teacher(ps, 'Pomona Sprout').
teacher(st, 'Sibyll Patricia Trelawney').
teacher(mh, 'Madam Hooch').
teacher(as, 'Aurora Sinistra').
teacher(cub, 'Cuthbert Binns').
teacher(bb, 'Bathsheba Babbling').
teacher(sv, 'Septima Vector').
teacher(chb, 'Charity Burbage').
teacher(wt, 'Wilkie Twycross').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compulsory courses for the MSc in Magic %%%%%%%% compCourse(SCN,CN,TID)
compCourse(astro, 'Astronomy', as).
compCourse(charms, 'Charms', ff).
compCourse(defence, 'Defence against the Dark Arts', qq).
compCourse(fly, 'Flying', mh).
compCourse(herb, 'Herbology', ps).
compCourse(history, 'History of Magic', cub).
compCourse(potions, 'Potions', ss).
compCourse(trans, 'Transfiguration', mm).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional courses for the MSc in Magic %%%%%%%  optCourse(SCN,CN,TID)
optCourse(runes, 'Study of Ancient Runes', bb).
optCourse(arith, 'Arithmancy', sv).
optCourse(muggle, 'Muggle Studies', chb).
optCourse(creatures, 'Care of Magical Creatures', rh).
optCourse(div, 'Divination', st).
optCourse(app, 'Apparition', wt).
optCourse(choir, 'Frog Choir', ff).
optCourse(quid, 'Quidditch', mh).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% already chosen courses %%%%%%%  enrolled_opt(SID,SCN)
enrolled_opt(hp,creatures).
enrolled_opt(hp,quid).
enrolled_opt(hp,div).
enrolled_opt(hg,runes).
enrolled_opt(hg,arith).
enrolled_opt(hg,muggle).
enrolled_opt(hg,creatures).
enrolled_opt(hg,div).
enrolled_opt(hg,app).
enrolled_opt(rw,creatures).
enrolled_opt(rw,quid).
enrolled_opt(rw,div).
enrolled_opt(ll,runes).
enrolled_opt(ll,app).
enrolled_opt(ll,choir).
enrolled_opt(cc,arith).
enrolled_opt(cc,quid).
enrolled_opt(cc,app).
enrolled_opt(tb,creatures).
enrolled_opt(tb,arith).
enrolled_opt(tb,div).
enrolled_opt(ha,runes).
enrolled_opt(ha,muggle).
enrolled_opt(ha,app).
enrolled_opt(cd,arith).
enrolled_opt(cd,muggle).
enrolled_opt(cd,quid).
enrolled_opt(nt,muggle).
enrolled_opt(nt,div).
enrolled_opt(nt,choir).
enrolled_opt(dm,runes).
enrolled_opt(dm,creatures).
enrolled_opt(dm,app).
enrolled_opt(gg,div).
enrolled_opt(gg,app).
enrolled_opt(gg,creatures).
enrolled_opt(vc,div).
enrolled_opt(vc,choir).
enrolled_opt(vc,creatures).
enrolled_opt(yd,runes).
enrolled_opt(yd,arith).
enrolled_opt(yd,choir).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3) enrolled(SID,SCN) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enrolled(SID,SCN):-enrolled_opt(SID,SCN).
enrolled(SID,SCN):-compCourse(SCN,_,_),student(SID,_,_).

% 4) teaches(TN,SCN) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

teaches(TN,SCN):-teacher(X,TN),compCourse(SCN,_,X).
teaches(TN,SCN):-teacher(X,TN),optCourse(SCN,_,X).

% 5) taughtBy(SN,TN) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

taughtBy(SN,TN):-enrolled(SID,SCN),student(SID,SN,_),teaches(TN,SCN).

% 6) takesOption(SN,CN) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

takesOption(SN,CN):-student(SID,SN,_),enrolled(SID,SCN),optCourse(SCN,CN,_).

% 7) takesAllOptions(SN,OptCourses) list in alphabetical order -OK %%%%%%%%%%%%

takesAllOptions(SN,OptCourses):-setof(CN,takesOption(SN,CN),OptCourses).

% 8) studentInHouse(House,Students) list in alphabetical order of SID -OK %%%%%

studentAndSID(House,SIDs):-setof(SID-SN,student(SID,SN,House),SIDs).

studentInHouse(House,Students):-
    studentAndSID(House,SIDs),
    findall(SN,member(_-SN,SIDs),Students).

% 9) studentsOnCourse(SCN,CN,StudentsByHouse) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

course(SCN,CN):-optCourse(SCN,CN,_);compCourse(SCN,CN,_).

takesComp(SN,CN):-student(SID,SN,_),enrolled(SID,SCN),compCourse(SCN,CN,_).

snSameHouseAndCourse(SCN,Housename,Students):-
    studentInHouse(Housename,Stu),
    compCourse(SCN,CN,_),
    setof(SN,(member(SN,Stu),takesComp(SN,CN)),Students).

snSameHouseAndCourse(SCN,Housename,Students):-
    studentInHouse(Housename,Stu),
    optCourse(SCN,CN,_),
    setof(SN,(member(SN,Stu),takesOption(SN,CN)),Students).

studentsG(SCN,CN,GList):-
    course(SCN,CN),
    (snSameHouseAndCourse(SCN,'gryffindor',GList)
     ;
     \+snSameHouseAndCourse(SCN,'gryffindor',GList),GList=[]
    ).

studentsH(SCN,CN,HList):-
    course(SCN,CN),
    (snSameHouseAndCourse(SCN,'hufflepuff',HList)
     ;
     \+snSameHouseAndCourse(SCN,'hufflepuff',HList),
     HList=[]
    ).   % I am pretty sure this looks ugly...

studentsR(SCN,CN,RList):
    -course(SCN,CN),
    (snSameHouseAndCourse(SCN,'ravenclaw',RList)
     ;
     \+snSameHouseAndCourse(SCN,'ravenclaw',RList),
     RList=[]
    ).

studentsS(SCN,CN,SList):-
    course(SCN,CN),
    (snSameHouseAndCourse(SCN,'slytherin',SList)
     ;
     \+snSameHouseAndCourse(SCN,'slytherin',SList),SList=[]
    ).

studentsOnCourse(SCN,CN,StudentsByHouse):-
    studentsG(SCN,CN,Glist),
    studentsH(SCN,CN,Hlist),
    studentsR(SCN,CN,Rlist),
    studentsS(SCN,CN,Slist),
    StudentsByHouse=[gryffindor-Glist,hufflepuff-Hlist,ravenclaw-Rlist,slytherin-Slist].

% 10> sharedCourse(SN1,SN2,CN) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sharedCourse(SN1,SN2,CN):-takesOption(SN1,CN),takesOption(SN2,CN),SN1\=SN2.

% 11> sameOptions(SN1,SN2,Courses) -OK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
diffOptions(Courses,Six):-member(C1,Courses),\+member(C1,Six).

sameOptions(SN1,SN2,Courses):-
    takesAllOptions(SN1,Courses),
    takesAllOptions(SN2,Courses),
    SN1\=SN2.

sameOptions(SN1,SN2,Courses):-
    SN1='Hermione Jean Granger',
    takesAllOptions(SN2,Courses),
    SN2\=SN1,
    takesAllOptions(SN1,Six),
    \+diffOptions(Courses,Six).
