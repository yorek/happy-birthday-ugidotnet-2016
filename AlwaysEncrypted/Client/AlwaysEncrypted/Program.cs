using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using Dapper;

namespace AlwaysEncrypted
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlConnectionStringBuilder strbldr = new SqlConnectionStringBuilder();
            strbldr.DataSource = "localhost";
            strbldr.InitialCatalog = "tempdb";
            strbldr.IntegratedSecurity = true;
            strbldr.ColumnEncryptionSetting = SqlConnectionColumnEncryptionSetting.Enabled;
            SqlConnection conn = new SqlConnection(strbldr.ConnectionString);

            conn.Open();
            try
            {
                var p = new DynamicParameters();
                p.Add("@firstName", "Davide", DbType.String, ParameterDirection.Input, 100);
                p.Add("@lastName", "Mauri", DbType.String, ParameterDirection.Input, 100);
                p.Add("@ssn", "123456789", DbType.String, ParameterDirection.Input, 100);
                p.Add("@birthDate", new DateTime(1977, 8, 12), DbType.DateTime2, ParameterDirection.Input, 7);

                conn.Execute("insert into dbo.Customers (first_name, last_name, ssn, birth_date) values (@firstName, @lastName, @ssn, @birthDate)", p);
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
