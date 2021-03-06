USE [master]
GO
/****** Object:  Database [TriathlonResults]    Script Date: 10/24/2008 07:30:24 ******/
CREATE DATABASE [TriathlonResults] ON  PRIMARY 
( NAME = N'TriathlonResults', FILENAME = N'C:\TriathlonResults.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TriathlonResults_log', FILENAME = N'C:\TriathlonResults_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'TriathlonResults', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TriathlonResults].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [TriathlonResults] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [TriathlonResults] SET ANSI_NULLS OFF
GO
ALTER DATABASE [TriathlonResults] SET ANSI_PADDING OFF
GO
ALTER DATABASE [TriathlonResults] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [TriathlonResults] SET ARITHABORT OFF
GO
ALTER DATABASE [TriathlonResults] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [TriathlonResults] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [TriathlonResults] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [TriathlonResults] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [TriathlonResults] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [TriathlonResults] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [TriathlonResults] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [TriathlonResults] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [TriathlonResults] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [TriathlonResults] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [TriathlonResults] SET  ENABLE_BROKER
GO
ALTER DATABASE [TriathlonResults] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [TriathlonResults] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [TriathlonResults] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [TriathlonResults] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [TriathlonResults] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [TriathlonResults] SET  READ_WRITE
GO
ALTER DATABASE [TriathlonResults] SET RECOVERY FULL
GO
ALTER DATABASE [TriathlonResults] SET  MULTI_USER
GO
ALTER DATABASE [TriathlonResults] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [TriathlonResults] SET DB_CHAINING OFF
GO
/****** Object:  Login [TriathlonResults]    Script Date: 10/24/2008 07:30:25 ******/
CREATE LOGIN [TriathlonResults] WITH PASSWORD='TriathlonResults', 
DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [TriathlonResults]
GO
/****** Object:  User [TriathlonResults]    Script Date: 10/24/2008 07:30:26 ******/
CREATE USER [TriathlonResults] FOR LOGIN [TriathlonResults] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Races]    Script Date: 10/24/2008 07:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Races](
	[RaceId] [int] NOT NULL,
	[RaceName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Races] PRIMARY KEY CLUSTERED 
(
	[RaceId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Athletes]    Script Date: 10/24/2008 07:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Athletes](
	[AthleteId] [int] NOT NULL,
	[AthleteName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Athletes] PRIMARY KEY CLUSTERED 
(
	[AthleteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sectors]    Script Date: 10/24/2008 07:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sectors](
	[SectorId] [int] NOT NULL,
	[SectorName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Sectors] PRIMARY KEY CLUSTERED 
(
	[SectorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SectorTimes]    Script Date: 10/24/2008 07:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SectorTimes](
	[RaceId] [int] NOT NULL,
	[AthleteId] [int] NOT NULL,
	[SectorId] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Duration] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SetSectorTime]    Script Date: 10/24/2008 07:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetSectorTime]
	@RaceId int,
	@SectorId int,
	@AthleteId int,
	@StartTime datetime,
	@EndTime datetime,
	@Duration int
AS
BEGIN
	--ensure ref tables are populated:
	if not exists (select 1 from Races where RaceId = @RaceId)
	 insert into Races(RaceId, RaceName) values(@RaceId, 'Unknown');
	if not exists (select 1 from Sectors where SectorId = @SectorId)
	 insert into Sectors(SectorId, SectorName) values(@SectorId, 'Unknown');
	if not exists (select 1 from Athletes where AthleteId = @AthleteId)
	 insert into Athletes(AthleteId, AthleteName) values(@AthleteId, 'Unknown');

	--populate sector:
if exists (select 1 from SectorTimes where RaceId=@RaceId and SectorId=@SectorId and AthleteId=@AthleteId)
	update SectorTimes set Duration=@Duration where RaceId=@RaceId and SectorId=@SectorId and AthleteId=@AthleteId;
else
	insert into SectorTimes(RaceId, SectorId, AthleteId, StartTime, EndTime, Duration)
	 values(@RaceId, @SectorId, @AthleteId, @StartTime, @EndTime, @Duration);
END
GO
/****** Object:  StoredProcedure [dbo].[GetRaces]    Script Date: 10/24/2008 07:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRaces]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Races;
END
GO
/****** Object:  ForeignKey [FK_SectorTimes_Athletes]    Script Date: 10/24/2008 07:30:27 ******/
ALTER TABLE [dbo].[SectorTimes]  WITH CHECK ADD  CONSTRAINT [FK_SectorTimes_Athletes] FOREIGN KEY([AthleteId])
REFERENCES [dbo].[Athletes] ([AthleteId])
GO
ALTER TABLE [dbo].[SectorTimes] CHECK CONSTRAINT [FK_SectorTimes_Athletes]
GO
/****** Object:  ForeignKey [FK_SectorTimes_Races]    Script Date: 10/24/2008 07:30:27 ******/
ALTER TABLE [dbo].[SectorTimes]  WITH CHECK ADD  CONSTRAINT [FK_SectorTimes_Races] FOREIGN KEY([RaceId])
REFERENCES [dbo].[Races] ([RaceId])
GO
ALTER TABLE [dbo].[SectorTimes] CHECK CONSTRAINT [FK_SectorTimes_Races]
GO
/****** Object:  ForeignKey [FK_SectorTimes_Sectors]    Script Date: 10/24/2008 07:30:27 ******/
ALTER TABLE [dbo].[SectorTimes]  WITH CHECK ADD  CONSTRAINT [FK_SectorTimes_Sectors] FOREIGN KEY([SectorId])
REFERENCES [dbo].[Sectors] ([SectorId])
GO
ALTER TABLE [dbo].[SectorTimes] CHECK CONSTRAINT [FK_SectorTimes_Sectors]
GO
GRANT DELETE ON [dbo].[Athletes] TO [TriathlonResults]
GO
GRANT INSERT ON [dbo].[Athletes] TO [TriathlonResults]
GO
GRANT SELECT ON [dbo].[Athletes] TO [TriathlonResults]
GO
GRANT UPDATE ON [dbo].[Athletes] TO [TriathlonResults]
GO
GRANT DELETE ON [dbo].[Races] TO [TriathlonResults]
GO
GRANT INSERT ON [dbo].[Races] TO [TriathlonResults]
GO
GRANT SELECT ON [dbo].[Races] TO [TriathlonResults]
GO
GRANT UPDATE ON [dbo].[Races] TO [TriathlonResults]
GO
GRANT DELETE ON [dbo].[Sectors] TO [TriathlonResults]
GO
GRANT INSERT ON [dbo].[Sectors] TO [TriathlonResults]
GO
GRANT SELECT ON [dbo].[Sectors] TO [TriathlonResults]
GO
GRANT UPDATE ON [dbo].[Sectors] TO [TriathlonResults]
GO
GRANT DELETE ON [dbo].[SectorTimes] TO [TriathlonResults]
GO
GRANT INSERT ON [dbo].[SectorTimes] TO [TriathlonResults]
GO
GRANT SELECT ON [dbo].[SectorTimes] TO [TriathlonResults]
GO
GRANT UPDATE ON [dbo].[SectorTimes] TO [TriathlonResults]
GO
GRANT EXECUTE ON [dbo].[GetRaces] TO [TriathlonResults]
GO
GRANT EXECUTE ON [dbo].[SetSectorTime] TO [TriathlonResults]
GO
ALTER LOGIN TriathlonResults WITH PASSWORD = 'TriathlonResults'
GO