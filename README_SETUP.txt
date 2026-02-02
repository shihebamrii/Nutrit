
# SETUP INSTRUCTIONS (NetBeans Ant Project)

1. **Libraries**:
   This project does not use Maven. You must manually add the following JARs to the project libraries in NetBeans (Right-click Project -> Properties -> Libraries -> Add JAR/Folder):
   
   - mysql-connector-java (v8.0+)
   - jakarta.jakartaee-web-api (v9.0+ or compatible with Tomcat 10)
   - jakarta.servlet.jsp.jstl (v2.0+)
   - jbcrypt (v0.4)
   - gson (v2.8+)

   *Tip: You might find these in your Tomcat `lib` folder or download them from Maven Central.*

2. **Database**:
   Run the SQL script located at `setup/schema.sql` in your MySQL Database.

3. **Run**:
   - Clean and Build the project.
   - Run on Apache Tomcat 10+ (required for Jakarta EE).

4. **URL**:
   Access at `http://localhost:8080/Nutrit` (Context path depends on NetBeans config).
