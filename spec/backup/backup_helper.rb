module BackupHelper
  
  def valid_backups(count = 9, sort = :none)
    backups = case sort
    when :none
      %w[ ey_my.cnf.20050430185242 ey_my.cnf.20080430185243 ey_my.cnf.20080430185242 
          ey_my.cnf.20060420185242 ey_my.cnf.20070430185242 ey_my.cnf.20060430185242
          ey_my.cnf.20060410185242 ey_my.cnf.20040430185242 ey_my.cnf.20050430185242 ]
    when :chronological
      %w[ ey_my.cnf.20080430185243 ey_my.cnf.20080430185242 ey_my.cnf.20070430185242
          ey_my.cnf.20060430185242 ey_my.cnf.20060420185242 ey_my.cnf.20060410185242
          ey_my.cnf.20050430185242 ey_my.cnf.20050430185242 ey_my.cnf.20040430185242 ]      
    end
    backups.first(count)
  end
  
  def invalid_backups(count = 9, sort = :none)
    backups = case sort
    when :none
      %w[ ey_my.cnf.20050430185242 ey_my.cnf.200a0430185243 ey_my.cnf.20080430185242 
          ey_my.cnf.20060420185242 ey_my.cnf.20070430185242 ey_my.cnf.20060430185242
          ey_my.cnf.20060410185242 ey_my.cnf.20040430185242 ey_my.cnf.20050430185242 ]
    when :chronological
      %w[ ey_my.cnf.200a0430185243 ey_my.cnf.20080430185242 ey_my.cnf.20070430185242
          ey_my.cnf.20060430185242 ey_my.cnf.20060420185242 ey_my.cnf.20060410185242
          ey_my.cnf.20050430185242 ey_my.cnf.20050430185242 ey_my.cnf.20040430185242 ]      
    end
    backups.first(count)
  end
  
end