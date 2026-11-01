@{
    # Error severity only: the lint gate is for syntax-level and dangerous-pattern
    # problems, not style. No code behavior was changed to satisfy warnings.
    Severity = @('Error')

    # SystemHealthReport.ps1 pings a well-known public DNS resolver on purpose as
    # an internet-connectivity probe; that is not a leaked internal hostname.
    ExcludeRules = @('PSAvoidUsingComputerNameHardcoded')
}
