def have_alert(alert-type, options={})
    have_selector(".ALERT-#{alert-type}", options)
end
