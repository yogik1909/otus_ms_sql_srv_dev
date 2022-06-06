USE master
GO

CREATE DATABASE [Golden Gingerbread]
ON PRIMARY (
NAME = N'Golden Gingerbread',
FILENAME = N'/storage/data_mssql_default/Golden Gingerbread.mdf',
SIZE = 8192 KB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 65536 KB
)
LOG ON (
NAME = N'Golden Gingerbread_log',
FILENAME = N'/storage/data_mssql_default/Golden Gingerbread_log.ldf',
SIZE = 8192 KB,
MAXSIZE = UNLIMITED,
FILEGROWTH = 65536 KB
)

CREATE TABLE [Golden Gingerbread].dbo.users (
user_id BINARY(16) NOT NULL
,user_name NVARCHAR(100) NOT NULL
,user_email NVARCHAR(100) NOT NULL
,user_admin BIT NOT NULL
,CONSTRAINT PK_USERS PRIMARY KEY CLUSTERED (user_id)
) ON [PRIMARY]
GO

CREATE TABLE [Golden Gingerbread].dbo.family (
fam_id BINARY(16) NOT NULL
,user_id BINARY(16) NOT NULL
,head_fam BINARY(16) NOT NULL
,CONSTRAINT PK_FAMILY PRIMARY KEY CLUSTERED (fam_id)
) ON [PRIMARY]
GO

CREATE TABLE [Golden Gingerbread].dbo.accounts (
acc_id BINARY(16) NOT NULL
,acc_par BINARY(16) NOT NULL
,is_folder BIT NOT NULL
,acc_owner BINARY(16) NOT NULL
,acc_disckip NVARCHAR(150) NOT NULL
,CONSTRAINT PK_ACCOUNTS PRIMARY KEY CLUSTERED (acc_id)
) ON [PRIMARY]
GO

CREATE TABLE [Golden Gingerbread].dbo.view_accounts (
view_id BINARY(16) NOT NULL
,view_accounts BINARY(16) NOT NULL
,view_name NVARCHAR(25) NOT NULL
,CONSTRAINT PK_VIEW_ACCOUNTS PRIMARY KEY CLUSTERED (view_id)
) ON [PRIMARY]
GO

CREATE TABLE [Golden Gingerbread].dbo.[transaction] (
tran_id BINARY(16) NOT NULL
,date_tran DATETIME2 NOT NULL
,acc_receipts BINARY(16) NULL
,acc_expens BINARY(16) NULL
,amount FLOAT NOT NULL
,CONSTRAINT PK_TRANSACTION PRIMARY KEY CLUSTERED (tran_id)
) ON [PRIMARY]
GO

CREATE TABLE [Golden Gingerbread].dbo.tran_lines (
tran_line_id BINARY(16) NOT NULL
,tran_id BINARY(16) NOT NULL
,amount FLOAT NOT NULL
,date_tran DATETIME2 NOT NULL
) ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX UK_tran_lines_tran_line_id
ON [Golden Gingerbread].dbo.tran_lines (tran_line_id)
GO


CREATE INDEX IDX_tran_lines_tran_id
ON [Golden Gingerbread].dbo.tran_lines (tran_id)
GO

ALTER TABLE [Golden Gingerbread].dbo.tran_lines
ADD CONSTRAINT tran_lines_fk0 FOREIGN KEY (tran_id) REFERENCES dbo.[transaction] (tran_id) ON UPDATE CASCADE
GO

ALTER TABLE [Golden Gingerbread].dbo.[transaction]
ADD CONSTRAINT transaction_fk0 FOREIGN KEY (acc_receipts) REFERENCES dbo.accounts (acc_id)
GO

ALTER TABLE [Golden Gingerbread].dbo.view_accounts
ADD CONSTRAINT view_accounts_fk0 FOREIGN KEY (view_accounts) REFERENCES dbo.accounts (acc_id)
GO

ALTER TABLE [Golden Gingerbread].dbo.accounts
ADD CONSTRAINT accounts_fk1 FOREIGN KEY (acc_owner) REFERENCES dbo.users (user_id)
GO

ALTER TABLE [Golden Gingerbread].dbo.family
ADD CONSTRAINT family_fk0 FOREIGN KEY (user_id) REFERENCES dbo.users (user_id)
GO