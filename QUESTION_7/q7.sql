with empdet as (
    --Gather all employee details with their department ids
    SELECT employee.EmployeeID,
        employeedepartmenthistory.DepartmentID,
        employeedepartmenthistory.StartDate,
        coalesce(
            --Get the end date or fill the end date with today if there is no end date
            employeedepartmenthistory.EndDate,
            current_date()
        ) as EndDate
    FROM adventureworks.employeedepartmenthistory
        left join employee on employee.EmployeeID = employeedepartmenthistory.EmployeeID
),
emptenure as (
    --Get all department names and department groups by department ids
    select department.GroupName as DeptGroupName,
        department.Name as DeptName,
        datediff (empdet.EndDate, empdet.StartDate) as Tenure,
        empdet.EmployeeID
    from empdet
        left join department on department.DepartmentID = empdet.DepartmentID
)
select --Show the final data
    DeptGroupName,
    DeptName,
    round(sum(Tenure) / count(EmployeeID), 0) as AverageTenure --Avarege tenure is total work day/no of employee with rounded value
from emptenure
group by DeptGroupName,
    DeptName
order by DeptGroupName,
    DeptName;