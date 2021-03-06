
GO
/****** Object:  StoredProcedure [dbo].[DeleteComment]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteComment]
(
	@CommentID int
)
AS
	SET NOCOUNT OFF;
DELETE FROM [dbo].[Comment] WHERE (([CommentID] = @CommentID))
GO
/****** Object:  StoredProcedure [dbo].[DoLogin]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DoLogin]
(
	@Username nvarchar(50),
	@Password nvarchar(50)
)
AS
	SET NOCOUNT ON;
SELECT     COUNT(*) as IsAuthenticated
FROM         ExportLogin
WHERE     (Username = @Username) AND (Password = @Password)
GO
/****** Object:  StoredProcedure [dbo].[GetAttachmentsByCommentId]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAttachmentsByCommentId]
(
	@CommentID int
)
AS
	SET NOCOUNT ON;
SELECT     RecordID, CommentID, PhysicalPath
FROM         Attachments
WHERE     (CommentID = @CommentID)
GO
/****** Object:  StoredProcedure [dbo].[GetAttachmentsByCommentIDandDiagramID]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAttachmentsByCommentIDandDiagramID]
(
	@CommentID int,
	@DiagramID int
)
AS
	SET NOCOUNT ON;
SELECT     RecordID, CommentID, PhysicalPath, VirtualPath, DiagramID
FROM         Attachments
WHERE     (CommentID = @CommentID) AND (DiagramID = @DiagramID)
GO
/****** Object:  StoredProcedure [dbo].[GetByCommentId]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetByCommentId]
(
	@CommentID int
)
AS
	SET NOCOUNT ON;
SELECT     CommentID, DiagramID, Username, Comment, CommentOrder, CommentDate
FROM         Comment
WHERE     (CommentID = @CommentID)
GO
/****** Object:  StoredProcedure [dbo].[GetCommentsByDiagramID]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommentsByDiagramID]
(
	@DiagramID int
)
AS
	SET NOCOUNT ON;
SELECT CommentID, DiagramID, Username, Comment, CommentOrder, CommentDate FROM dbo.Comment WHERE DiagramID = @DiagramID ORDER BY CommentOrder DESC
GO
/****** Object:  StoredProcedure [dbo].[SaveAttachment]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveAttachment]
(
	@DiagramID int,
	@PhysicalPath nvarchar(MAX),
	@VirtualPath nvarchar(MAX),
	@CommentID int
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Attachments] ([DiagramID], [PhysicalPath],[VirtualPath], [CommentID]) VALUES (@DiagramID, @PhysicalPath, @VirtualPath, @CommentID)
GO
/****** Object:  StoredProcedure [dbo].[SaveComment]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveComment]
(
	@DiagramID int,
	@Username nvarchar(50),
	@Comment nvarchar(MAX),
	@CommentOrder int,
	@CommentDate datetime
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Comment] ([DiagramID], [Username], [Comment], [CommentOrder], [CommentDate]) VALUES (@DiagramID, @Username, @Comment, @CommentOrder, @CommentDate)
GO
/****** Object:  StoredProcedure [dbo].[SaveCommentWithCommentID]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SaveCommentWithCommentID]
(
	@DiagramID int,
	@Username nvarchar(50),
	@Comment nvarchar(MAX),
	@CommentOrder int,
	@CommentDate datetime,
	@CommentID int out
)
AS
	SET NOCOUNT OFF;
INSERT INTO [dbo].[Comment] ([DiagramID], [Username], [Comment], [CommentOrder], [CommentDate]) VALUES (@DiagramID, @Username, @Comment, @CommentOrder, @CommentDate)

SET @CommentID = @@IDENTITY
GO
/****** Object:  Table [dbo].[Attachments]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attachments](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[CommentID] [int] NOT NULL,
	[PhysicalPath] [nvarchar](max) NOT NULL,
	[VirtualPath] [nvarchar](max) NULL,
	[DiagramID] [int] NOT NULL,
 CONSTRAINT [PK_Attachments] PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Comment]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[DiagramID] [int] NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[CommentOrder] [int] NOT NULL,
	[CommentDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExportLogin]    Script Date: 29/07/2015 3:17:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExportLogin](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ExportLogins] PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT into ExportLogin(Username, Password) VALUES('admin','admin');
GO
GO

/****** Object:  Table [dbo].[DiagramSize]    Script Date: 29/07/2015 3:20:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DiagramSize](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[DiagramID] [int] NOT NULL,
	[Percentage] [float] NOT NULL,
 CONSTRAINT [PK_DiagramSize] PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

