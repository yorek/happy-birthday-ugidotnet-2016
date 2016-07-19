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
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = "localhost";
            builder.InitialCatalog = "tempdb";
            builder.IntegratedSecurity = true;
            builder.ApplicationName = "AlwaysEncrypted Demo";
            builder.ColumnEncryptionSetting = SqlConnectionColumnEncryptionSetting.Enabled;
            SqlConnection conn = new SqlConnection(builder.ConnectionString);

            conn.Open();
            try
            {
                InsertRow(conn, "Davide", "Mauri", "123456789", new DateTime(1977, 8, 12));
                InsertRow(conn, "John", "Doe", "987654321", new DateTime(2001, 1, 1));

                Console.WriteLine("Rows Added.");
                Console.WriteLine("Press ENTER to continue");
                Console.ReadLine();

                Console.WriteLine("Retrieving Customer using SSN.");
                var result = conn.Query("select first_name, last_name, birth_date from dbo.Customers where ssn = @ssn", new { ssn = "123456789" }).First();
                Console.WriteLine(result.first_name + " " + result.last_name);
                Console.WriteLine("Press ENTER to continue");
                Console.ReadLine();
            }
            finally
            {
                conn.Close();
            }
        }

        private static void InsertRow(SqlConnection conn, string name, string surname, string ssn, DateTime birthDate)
        {
            var p = new DynamicParameters();
            p.Add("@firstName", name, DbType.String, ParameterDirection.Input, 100);
            p.Add("@lastName", surname, DbType.String, ParameterDirection.Input, 100);
            p.Add("@ssn", ssn, DbType.String, ParameterDirection.Input, 100);
            p.Add("@birthDate", birthDate, DbType.DateTime2, ParameterDirection.Input, 7);

            conn.Execute("insert into dbo.Customers (first_name, last_name, ssn, birth_date) values (@firstName, @lastName, @ssn, @birthDate)", p);
        }       
    }
}
