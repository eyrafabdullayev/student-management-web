/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author eyraf
 */
public class StudentDatabase {

    public static Connection connect() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/studentmanapp";
            String username = "root"; //mysql username
            String password = "12345"; //mysql password

            Connection conn = DriverManager.getConnection(url, username, password);
            return conn;
        } catch (Exception e) {
            return null;
        }
    }

    public static List<Student> getAll() {
        List<Student> result = new ArrayList<>();

        try (Connection conn = connect()) {

            PreparedStatement stmt = conn.prepareStatement("select * from student");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(new Student(rs.getInt("id"), rs.getString("name"), rs.getString("surname"), rs.getInt("age")));
            }

            return result;
        } catch (Exception e) {
            return result;
        }
    }

    public static List<Student> get(String name, String surname, Integer age) {
        if ((name.isEmpty() || name == null) && (surname.isEmpty() || surname == null) && (age == null)) {
            return getAll();
        }

        List<Student> result = new ArrayList<>();
        try (Connection conn = connect()) {

            StringBuilder query = new StringBuilder("select * from student where name = name ");
            if (name != null && !name.isEmpty()) {
                query.append("and name like ?");
            }

            if (surname != null && !surname.isEmpty()) {
                query.append("and surname like ?");
            }

            if (age != null) {
                query.append("and age = ?");
            }

            PreparedStatement stmt = conn.prepareStatement(query.toString());

            int n = 0;
            if (name != null && !name.isEmpty()) {
                stmt.setString(++n, "%" + name + "%");
            }

            if (surname != null && !surname.isEmpty()) {
                stmt.setString(++n, "%" + surname + "%");
            }

            if (age != null) {
                stmt.setInt(++n, age);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(new Student(rs.getInt("id"), rs.getString("name"), rs.getString("surname"), rs.getInt("age")));
            }

            return result;
        } catch (Exception e) {
            return null;
        }
    }

    public static int insert(String name, String surname, Integer age) {
        try (Connection conn = connect()) {

            PreparedStatement stmt = conn.prepareStatement("insert student(name,surname,age) values(?,?,?)");
            stmt.setString(1, name);
            stmt.setString(2, surname);
            stmt.setInt(3, age);

            return stmt.executeUpdate();
        } catch (Exception e) {
            return 0;
        }
    }

    public static int update(Student s) {
        try (Connection conn = connect()) {

            StringBuilder query = new StringBuilder("update student set name=name ");

            if (!s.getName().isEmpty() && s.getName() != null) {
                query.append(", name = ?");
            }

            if (!s.getSurname().isEmpty() && s.getSurname() != null) {
                query.append(", surname = ?");
            }

            if (s.getAge() != null) {
                query.append(", age = ?");
            }

            query.append(" where id = ?");

            PreparedStatement stmt = conn.prepareStatement(query.toString());

            int n = 0;

            if (!s.getName().isEmpty() && s.getName() != null) {
                stmt.setString(++n, s.getName());
            }

            if (!s.getSurname().isEmpty() && s.getSurname() != null) {
                stmt.setString(++n, s.getSurname());
            }

            if (s.getAge() != null) {
                stmt.setInt(++n, s.getAge());
            }

            stmt.setInt(++n, s.getId());

            return stmt.executeUpdate();
        } catch (Exception e) {
            return 0;
        }
    }

    public static int delete(int id) {
        try (Connection conn = connect()) {

            PreparedStatement stmt = conn.prepareStatement("delete from student where id = ?");
            stmt.setInt(1, id);

            return stmt.executeUpdate();
        } catch (Exception ex) {
            return 0;
        }
    }

    public static Student getStudentById(int id) {
        Student s = null;
        
        try (Connection conn = connect()) {

            PreparedStatement stmt = conn.prepareStatement("select * from student where id = ?");
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                s = new Student(rs.getInt("id"), rs.getString("name"), rs.getString("surname"), rs.getInt("age"));
            }
            
            return s;
        } catch (Exception ex) {
            return null;
        }
    }
}
