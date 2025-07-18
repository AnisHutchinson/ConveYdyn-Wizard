
using Microsoft.EntityFrameworkCore;

public class AccountDb : DbContext
{
    public AccountDb(DbContextOptions<AccountDb> options)
        : base(options) { }
//il va creer une table accounts qui contient tous les Acoount :)
    public DbSet<Account> Accounts { get; set; }
}