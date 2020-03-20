<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="Connection.Connect"%>
<%@page import="java.sql.ResultSetMetaData"%>
<html>
    <head>
        <title>ADD EXAM</title>
    </head>
    <body>
    <a href="addCo.jsp">Add CO</a><br/>
        <a href="addExam.jsp">Add Exam</a><br/>
        <a href="addQue.jsp">Add Question</a><br/>
        <a href="addMarks.jsp">Add Marks</a><br/>
        <a href="calculateAttainment.jsp">Calculate Attainment</a><br/>
        <br/><br/>
    <form method="POST">
        <%-- ExamID:        <input type="number" name="exam_id"/><br/> --%>
        ExamName:     <input type="text" name="exam_name"/><br/>
        ExamType ID:  <input type="number" name="exam_type"/><br/>
        <%-- EXAM Date:     <input type="date" name="exam_date"/><br/> --%>
        SubjectID:     <input type="number" name="subject_id"/><br/>
        TotalMaxMarks:      <input type="number" name="total_max_marks"/><br/>
        Weightage: <input type="number" name="weightage"/><br/>
       <!-- MaxWeightMarks:<input type="text" name="max_weighted_marks"/><br/>:::Calculated Based on Type Of Exam::: -->
        Batch:         <input type="number" name="batch"/><br/>
        FacultyID:     <input type="number" name="faculty_id"/><br/>
        <button type="submit" name="submit" value="submit">Submit</button>
        <%
            Connect con=null;
            ResultSet rs=null;
            ResultSetMetaData mtdt=null;
            con=new Connect();
            /*float exam_weightage=0;
            int n_marks1 = 0;
            float MaxWeightMarks = 0;*/
            if (request.getParameter("submit") != null){
            int i = Integer.parseInt(request.getParameter("exam_type"));
            rs=con.SelectData("select * from examtype_master where examTypeID="+i+";");
            if (con.Ins_Upd_Del("insert into exam_master(examName,batch,totalMaxMarks,weightage,subjectID,examTypeID,facultyID) VALUES('"+request.getParameter("exam_name")+"',"+request.getParameter("batch")+","+request.getParameter("total_max_marks")+","+request.getParameter("weightage")+","+request.getParameter("subject_id")+","+i+","+request.getParameter("faculty_id")+");"))
                out.println("<script>alert('Record inserted......');</script>");
                else
                out.println("<script>alert('Record was not inserted......');</script>");
            }
        %>
        </form>
    </body>
</html>