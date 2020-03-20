<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="Connection.Connect"%>
<%@page import="java.sql.ResultSetMetaData"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <title>ADD CO</title>
        <script src="js/jquery-3.2.1.min.js"></script>

    </head>
    <body>
    <a href="addCo.jsp">Add CO</a><br/>
        <a href="addExam.jsp">Add Exam</a><br/>
        <a href="addQue.jsp">Add Question</a><br/>
        <a href="addMarks.jsp">Add Marks</a><br/>
        <a href="calculateAttainment.jsp">Calculate Attainment</a><br/>
        <br/><br/>
    <form method="POST">
        SubjectID:        <input type="number" name="subject_id"/><br/>
        No of CO:  <input type="number" name="cono" id="cono"/><br/>
            <input onclick="addRow(this.form);" type="button" name="addbut" value="Add"><br/>
            <div id="cos">
            </div>
        FacultyID:     <input type="number" name="faculty_id"/><br/>
        <button type="submit" name="submit" value="submit">Submit</button>
        <script type="text/javascript">
            function addRow(frm) {
                var cono = frm.cono.value;
                var n = 1;
                while(n<=cono){
                    jQuery('#cos').append('CoStatement '+n+' :<input type="text" name="co'+(n)+'"><br/>');
                    n++;
                }
                frm.addbut.disabled="true";
            }
        </script>
        <%
            Connect con=null;
            ResultSet rs=null;
            ResultSetMetaData mtdt=null;
            con=new Connect();
            if (request.getParameter("submit") != null){
            int conos = Integer.parseInt(request.getParameter("cono"));
            int x = 1;
            while(x<=conos){
                if (con.Ins_Upd_Del("insert into co_master(coID,coStatement,subjectID,facultyID) VALUES("+x+",'"+request.getParameter("co"+x)+"',"+request.getParameter("subject_id")+","+request.getParameter("faculty_id")+");"))
                    out.println("<script>alert('CO "+x+" inserted......');</script>");
                else
                    out.println("<script>alert('CO was not inserted......');</script>");
                x++;
            }
            }
        %>
        </form>
    </body>
</html>