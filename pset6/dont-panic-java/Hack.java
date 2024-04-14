import java.sql.*;
import java.util.*;

public class Hack {
    public static void main(String[] args) throws Exception
    {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter new password: ");
        String password = scanner.nextLine();
        Connection sqliteConnection = DriverManager.getConnection("jdbc:sqlite:dont-panic.db");

        String query = """
            UPDATE "users"
            SET "password" = ?
            WHERE "username" = 'admin';
        """;
        
        PreparedStatement sqliteStatement = sqliteConnection.prepareStatement(query);
        sqliteStatement.setString(1, password);
        sqliteStatement.executeUpdate();
        sqliteConnection.close();
        scanner.close();
    }
}
