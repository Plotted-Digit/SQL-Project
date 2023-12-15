with empdet as (
    SELECT employee.EmployeeID,
        employeedepartmenthistory.DepartmentID,
        employeedepartmenthistory.StartDate,
        coalesce(
            employeedepartmenthistory.EndDate,
            current_date()
        ) as EndDate
    FROM adventureworks.employeedepartmenthistory
        left join employee on employee.EmployeeID = employeedepartmenthistory.EmployeeID
),
emptenure as (
    select department.GroupName as DeptGroupName,
        department.Name as DeptName,
        datediff(empdet.EndDate, empdet.StartDate) as Tenure,
        empdet.EmployeeID
    from empdet
        left join department on department.DepartmentID = empdet.DepartmentID
)
select DeptGroupName,
    DeptName,
    round(sum(Tenure) / count(EmployeeID), 0) as AverageTenure
from emptenure
group by DeptGroupName,
    DeptName
order by DeptGroupName,
    DeptName;