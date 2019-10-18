USE [DADOSMP10]
GO

/****** Object:  Table [dbo].[SZ1010]    Script Date: 07/05/2010 16:20:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SZ1010](
	[Z1_FILIAL] [varchar](2) NOT NULL,
	[Z1_CODJOB] [varchar](9) NOT NULL,
	[Z1_CLIENTE] [varchar](6) NOT NULL,
	[Z1_LOJA] [varchar](2) NOT NULL,
	[Z1_EVENTO] [varchar](30) NOT NULL,
	[Z1_LOCAL] [varchar](30) NOT NULL,
	[Z1_ENDEREC] [varchar](30) NOT NULL,
	[Z1_REFER] [varchar](30) NOT NULL,
	[Z1_ATENDE] [varchar](30) NOT NULL,
	[Z1_DIRTEC] [varchar](30) NOT NULL,
	[Z1_RESPONS] [varchar](30) NOT NULL,
	[Z1_DTCARGM] [varchar](8) NOT NULL,
	[Z1_NUMCJ] [varchar](6) NOT NULL,
	[Z1_DTVGM1] [varchar](8) NOT NULL,
	[Z1_DTVGM2] [varchar](8) NOT NULL,
	[Z1_DTMONT1] [varchar](8) NOT NULL,
	[Z1_DTMONT2] [varchar](8) NOT NULL,
	[Z1_DTEVINI] [varchar](8) NOT NULL,
	[Z1_DTEVFIM] [varchar](8) NOT NULL,
	[Z1_DTDESM1] [varchar](8) NOT NULL,
	[Z1_DTDESM2] [varchar](8) NOT NULL,
	[Z1_DTVGM3] [varchar](8) NOT NULL,
	[Z1_DTVGM4] [varchar](8) NOT NULL,
	[Z1_STATUS] [varchar](1) NOT NULL,
	[Z1_NUMC5] [varchar](6) NOT NULL,
	[D_E_L_E_T_] [varchar](1) NOT NULL,
	[R_E_C_N_O_] [int] NOT NULL,
	[R_E_C_D_E_L_] [int] NOT NULL,
	[Z1_CONTATO] [varchar](30) NOT NULL,
	[Z1_HRCARGM] [varchar](5) NOT NULL,
	[Z1_HRVGM1] [varchar](5) NOT NULL,
	[Z1_HRVGM2] [varchar](5) NOT NULL,
	[Z1_HRMONT1] [varchar](5) NOT NULL,
	[Z1_HRMONT2] [varchar](5) NOT NULL,
	[Z1_HREVINI] [varchar](5) NOT NULL,
	[Z1_HREVFIM] [varchar](5) NOT NULL,
	[Z1_HRDESM1] [varchar](5) NOT NULL,
	[Z1_HRDESM2] [varchar](5) NOT NULL,
	[Z1_HRVGM3] [varchar](5) NOT NULL,
	[Z1_HRVGM4] [varchar](5) NOT NULL,
	[Z1_DESCJOB] [image] NULL,
	[Z1_CONTTEL] [varchar](14) NOT NULL,
	[Z1_OBSGERA] [image] NULL,
	[Z1_TETPVEI] [varchar](30) NOT NULL,
	[Z1_TEQTPE] [float] NOT NULL,
	[Z1_TEDTSAI] [varchar](8) NOT NULL,
	[Z1_TEDIASD] [float] NOT NULL,
	[Z1_TEDTRET] [varchar](8) NOT NULL,
	[Z1_TERESCO] [varchar](1) NOT NULL,
	[Z1_TEOBS] [image] NULL,
	[Z1_HEPERIO] [float] NOT NULL,
	[Z1_HEQTDPE] [float] NOT NULL,
	[Z1_HERESCO] [varchar](1) NOT NULL,
	[Z1_HEOBS] [image] NULL,
	[Z1_CANUMMO] [float] NOT NULL,
	[Z1_CANUMDE] [float] NOT NULL,
	[Z1_CARESCO] [varchar](1) NOT NULL,
	[Z1_CAOBS] [image] NULL,
	[Z1_TCTPVEI] [varchar](30) NOT NULL,
	[Z1_TCCOMPR] [float] NOT NULL,
	[Z1_TCPESO] [float] NOT NULL,
	[Z1_TCVALOR] [float] NOT NULL,
	[Z1_TCOBS] [image] NULL,
	[Z1_ETVERBA] [float] NOT NULL,
	[Z1_ETDIAAL] [float] NOT NULL,
	[Z1_ETRESP] [varchar](30) NOT NULL,
	[Z1_ETOBS] [image] NULL,
	[Z1_USUARIO] [varchar](30) NOT NULL,
	[Z1_DTHRUSO] [varchar](17) NOT NULL,
	[Z1_DTENINI] [varchar](8) NOT NULL,
	[Z1_HRENINI] [varchar](5) NOT NULL,
	[Z1_FORASP] [varchar](1) NOT NULL,
	[Z1_NUMSERV] [varchar](6) NOT NULL,
 CONSTRAINT [SZ1010_PK] PRIMARY KEY CLUSTERED 
(
	[R_E_C_N_O_] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_FILIAL_DF]  DEFAULT ('  ') FOR [Z1_FILIAL]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CODJOB_DF]  DEFAULT ('         ') FOR [Z1_CODJOB]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CLIENTE_DF]  DEFAULT ('      ') FOR [Z1_CLIENTE]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_LOJA_DF]  DEFAULT ('  ') FOR [Z1_LOJA]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_EVENTO_DF]  DEFAULT ('                              ') FOR [Z1_EVENTO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_LOCAL_DF]  DEFAULT ('                              ') FOR [Z1_LOCAL]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_ENDEREC_DF]  DEFAULT ('                              ') FOR [Z1_ENDEREC]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_REFER_DF]  DEFAULT ('                              ') FOR [Z1_REFER]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_ATENDE_DF]  DEFAULT ('                              ') FOR [Z1_ATENDE]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DIRTEC_DF]  DEFAULT ('                              ') FOR [Z1_DIRTEC]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_RESPONS_DF]  DEFAULT ('                              ') FOR [Z1_RESPONS]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTCARGM_DF]  DEFAULT ('        ') FOR [Z1_DTCARGM]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_NUMCJ_DF]  DEFAULT ('      ') FOR [Z1_NUMCJ]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTVGM1_DF]  DEFAULT ('        ') FOR [Z1_DTVGM1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTVGM2_DF]  DEFAULT ('        ') FOR [Z1_DTVGM2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTMONT1_DF]  DEFAULT ('        ') FOR [Z1_DTMONT1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTMONT2_DF]  DEFAULT ('        ') FOR [Z1_DTMONT2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTEVINI_DF]  DEFAULT ('        ') FOR [Z1_DTEVINI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTEVFIM_DF]  DEFAULT ('        ') FOR [Z1_DTEVFIM]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTDESM1_DF]  DEFAULT ('        ') FOR [Z1_DTDESM1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTDESM2_DF]  DEFAULT ('        ') FOR [Z1_DTDESM2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTVGM3_DF]  DEFAULT ('        ') FOR [Z1_DTVGM3]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTVGM4_DF]  DEFAULT ('        ') FOR [Z1_DTVGM4]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_STATUS_DF]  DEFAULT (' ') FOR [Z1_STATUS]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_NUMC5_DF]  DEFAULT ('      ') FOR [Z1_NUMC5]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_D_E_L_E_T__DF]  DEFAULT (' ') FOR [D_E_L_E_T_]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_R_E_C_N_O__DF]  DEFAULT ((0)) FOR [R_E_C_N_O_]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_R_E_C_D_E_L__DF]  DEFAULT ((0)) FOR [R_E_C_D_E_L_]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CONTATO_DF]  DEFAULT ('                              ') FOR [Z1_CONTATO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRCARGM_DF]  DEFAULT ('     ') FOR [Z1_HRCARGM]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRVGM1_DF]  DEFAULT ('     ') FOR [Z1_HRVGM1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRVGM2_DF]  DEFAULT ('     ') FOR [Z1_HRVGM2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRMONT1_DF]  DEFAULT ('     ') FOR [Z1_HRMONT1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRMONT2_DF]  DEFAULT ('     ') FOR [Z1_HRMONT2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HREVINI_DF]  DEFAULT ('     ') FOR [Z1_HREVINI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HREVFIM_DF]  DEFAULT ('     ') FOR [Z1_HREVFIM]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRDESM1_DF]  DEFAULT ('     ') FOR [Z1_HRDESM1]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRDESM2_DF]  DEFAULT ('     ') FOR [Z1_HRDESM2]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRVGM3_DF]  DEFAULT ('     ') FOR [Z1_HRVGM3]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRVGM4_DF]  DEFAULT ('     ') FOR [Z1_HRVGM4]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CONTTEL_DF]  DEFAULT ('              ') FOR [Z1_CONTTEL]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TETPVEI_DF]  DEFAULT ('                              ') FOR [Z1_TETPVEI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TEQTPE_DF]  DEFAULT ((0)) FOR [Z1_TEQTPE]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TEDTSAI_DF]  DEFAULT ('        ') FOR [Z1_TEDTSAI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TEDIASD_DF]  DEFAULT ((0)) FOR [Z1_TEDIASD]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TEDTRET_DF]  DEFAULT ('        ') FOR [Z1_TEDTRET]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TERESCO_DF]  DEFAULT (' ') FOR [Z1_TERESCO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HEPERIO_DF]  DEFAULT ((0)) FOR [Z1_HEPERIO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HEQTDPE_DF]  DEFAULT ((0)) FOR [Z1_HEQTDPE]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HERESCO_DF]  DEFAULT (' ') FOR [Z1_HERESCO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CANUMMO_DF]  DEFAULT ((0)) FOR [Z1_CANUMMO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CANUMDE_DF]  DEFAULT ((0)) FOR [Z1_CANUMDE]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_CARESCO_DF]  DEFAULT (' ') FOR [Z1_CARESCO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TCTPVEI_DF]  DEFAULT ('                              ') FOR [Z1_TCTPVEI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TCCOMPR_DF]  DEFAULT ((0)) FOR [Z1_TCCOMPR]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TCPESO_DF]  DEFAULT ((0)) FOR [Z1_TCPESO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_TCVALOR_DF]  DEFAULT ((0)) FOR [Z1_TCVALOR]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_ETVERBA_DF]  DEFAULT ((0)) FOR [Z1_ETVERBA]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_ETDIAAL_DF]  DEFAULT ((0)) FOR [Z1_ETDIAAL]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_ETRESP_DF]  DEFAULT ('                              ') FOR [Z1_ETRESP]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_USUARIO_DF]  DEFAULT ('                              ') FOR [Z1_USUARIO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTHRUSO_DF]  DEFAULT ('                 ') FOR [Z1_DTHRUSO]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_DTENINI_DF]  DEFAULT ('        ') FOR [Z1_DTENINI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_HRENINI_DF]  DEFAULT ('     ') FOR [Z1_HRENINI]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_FORASP_DF]  DEFAULT (' ') FOR [Z1_FORASP]
GO

ALTER TABLE [dbo].[SZ1010] ADD  CONSTRAINT [SZ1010_Z1_NUMSERV_DF]  DEFAULT ('      ') FOR [Z1_NUMSERV]
GO


