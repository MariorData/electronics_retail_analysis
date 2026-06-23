let
    // Reference source query
    Source = sales,

    // Get min and max dates
    MinDate = List.Min(Source[OrderDate]),
    MaxDate = List.Max(Source[OrderDate]),

    // Expand to full years
    StartDate = #date(Date.Year(MinDate), 1, 1),
    EndDate = #date(Date.Year(MaxDate), 12, 31),

    // Create date list
    DateList = List.Dates(
        StartDate,
        Duration.Days(EndDate - StartDate) + 1,
        #duration(1, 0, 0, 0)
    ),

    // Convert to table
    Calendar = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),

    // Set type
    #"Changed Type" = Table.TransformColumnTypes(Calendar, {{"Date", type date}}),

    // Optional calendar attributes
    #"Added Year" = Table.AddColumn(#"Changed Type", "Year", each Date.Year([Date]), Int64.Type),
    #"Added Month" = Table.AddColumn(#"Added Year", "Month", each Date.Month([Date]), Int64.Type),
    #"Added Month Name" = Table.AddColumn(#"Added Month", "Month Name", each Date.MonthName([Date]), type text),
    #"Added Quarter" = Table.AddColumn(#"Added Month Name", "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text)
in
    #"Added Quarter"
