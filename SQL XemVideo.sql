4	create database VideoAppp
5	use VideoAppp;
6	CREATE TABLE [User] (
7	    Id NVARCHAR(50) PRIMARY KEY,
8	    Password NVARCHAR(255) NOT NULL,
9	    Email NVARCHAR(100) NOT NULL,
10	    FullName NVARCHAR(100),
11	    Admin BIT
12	);
13	
14	CREATE TABLE Video (
15	    Id NVARCHAR(50) PRIMARY KEY,
16	    Title NVARCHAR(255) NOT NULL,
17	    Poster NVARCHAR(255),
18	    Views INT DEFAULT 0,
19	    Description NVARCHAR(MAX),
20	    Active BIT,
21	    Link NVARCHAR(255)
22	);
23	CREATE TABLE Favorite (
24	    Id INT IDENTITY(1,1) PRIMARY KEY,
25	    UserId NVARCHAR(50) NOT NULL,
26	    VideoId NVARCHAR(50) NOT NULL,
27	    LikeDate DATETIME DEFAULT GETDATE(),
28	
29	    CONSTRAINT FK_Favorite_User
30	        FOREIGN KEY (UserId) REFERENCES [User](Id),
31	
32	    CONSTRAINT FK_Favorite_Video
33	        FOREIGN KEY (VideoId) REFERENCES Video(Id)
34	);
35	
36	CREATE TABLE Share (
37	    Id INT IDENTITY(1,1) PRIMARY KEY,
38	    UserId NVARCHAR(50) NOT NULL,
39	    VideoId NVARCHAR(50) NOT NULL,
40	    Emails NVARCHAR(255),
41	    ShareDate DATETIME DEFAULT GETDATE(),
42	
43	    CONSTRAINT FK_Share_User
44	        FOREIGN KEY (UserId) REFERENCES [User](Id),
45	
46	    CONSTRAINT FK_Share_Video
47	        FOREIGN KEY (VideoId) REFERENCES Video(Id)
48	);
49	
50	CREATE TABLE History (
51	    Id INT IDENTITY(1,1) PRIMARY KEY,
52	    UserId NVARCHAR(50) NOT NULL,
53	    VideoId NVARCHAR(50) NOT NULL,
54	    ViewDate DATETIME DEFAULT GETDATE(),
55	
56	    CONSTRAINT FK_History_User
57	        FOREIGN KEY (UserId) REFERENCES [User](Id),
58	
59	    CONSTRAINT FK_History_Video
60	        FOREIGN KEY (VideoId) REFERENCES Video(Id)
61	);
62	
