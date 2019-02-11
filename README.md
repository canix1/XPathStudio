# XPathStudio
XPathStudio 


A tool to simplify searching local and remote eventlogs. It has a collection of XPath queries in an .json file that is available for selection in a list. Some XPath queries are prepared for own input to prepared fields.
In this example you need to add a TargetUserName value of your own , replacing REPLACEUSERNAME:

```
<!--- Name:Logon event by user name -->
<!-- Replace REPLACEUSERNAME -->
<QueryList>
<Query Id='0' Path='Security'>
<Select Path='Security'>*[System[EventID=4624]] and *[EventData[Data[@Name='TargetUserName']='REPLACEUSERNAME']]</Select>
</Query>
</QueryList>
```

Run against you local machine or a list of hosts. Do your filtering in XPath and/or in the Display Filter option.

Have a couple of Sysmon Xpath queries available. If you have your own please share and I will update the .json file.

#### Remember that you need to run the script as an elevated admin to read the Security and Sysmon log.
#### This is not a log collector! No database is used so if a lot data is retrieved performance will be affected.

![](https://github.com/canix1/XPathStudio/blob/master/XPathStudio.png)
