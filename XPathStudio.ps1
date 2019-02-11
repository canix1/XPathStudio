################################################################################################
# XPathStudio.ps1
# 
# AUTHOR: Robin Granberg (robin.g@home.se)
#
# THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
# FITNESS FOR A PARTICULAR PURPOSE.
#
################################################################################################
<#-------------------------------------------------------------------------------
!! Version 1.0
10 Feb 2019


-------------------------------------------------------------------------------#> 

Param
(
    )

begin
{

$CurrentFSPath = split-path -parent $MyInvocation.MyCommand.Path

#JSON Input file wiht XML based XPath queries
$JSONFile = $CurrentFSPath + "\xpathfilter.json"



#Load Presentation Framework
Add-Type -Assembly PresentationFramework





$picCritical = @"
iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xMzQDW3oAAAKTSURBVDhPrZPdS5NxFMd9p/0BDQopvCiopnghglfe+AdYN6suYkiUF2uRXTmLVDaYMnEDSaKsLVqaS6ZLZuY2dLam1nLzZUvbLs
JtKkhYOGfefDvniWdNNy+CHvjA73fO95znvDxPHoD/Qk4jMzI8AqPBCHWzWoDPbDusE8ky2Efs6OzUw2S2YGzcjZnZgACf2cY+1hyOO3CxvLCgt/cxPA4nlvtf44tWh9CNRgQVDfDfuYs5Qw/c9jFBw9rM2PSB38KCgNWGmPIWfnR1IXz6FKI1NQhXV+PTyRP4eluFlWsKzFgGBW1mZelEXPIUVZJQtyAVjbIA6+3t+CCRYFpyDKGm
JiTIFltZwfLNRriGHUKb9PxNxEPk/hfML5FQqbBpMrFAeCJKJfwKBdaSKWzTPdDdjY6qKnh1f+YoLkBIxBvhYS6q72P2uBRBEq739eEXObf39hCJxRHf38e8Xo97+fnoKSjApPyqEMOx6US8Xt7MZ/llzFVWYpzEjuJirBoM+Lazg43dXSwZjWgheR9hp0TOigohhmOzEs3VX8RoYSEGyeyuq8MiVZWgiuLJJCIDA+iVSvGKfEOUyF
Venp1IbM3XcB1WFpWVYclqxSY5gy4X5onVVAprDgeelJbiHWk89ZeyWxOH7dXo4KmtRYiSbJEj7POhmSQPicjCAn6S7Tsl05WUwNemzR42w6vkldrlVxBobcXGxISQ5BnxhjAXFWErHMZHrRbmM2fhso1mr58RP0j30+cYOi+DlQbOg7URb4kp4hG11H/uAvykOfKDZMRfxElve/9Ag2maw6RMBg/hpfNMm0aohDVH/iIi/BYumfvn
YfJmGD6zjX2ZlYgcuGTCQ+SN8HoZPouDzUVO47+DvN9nk5bsfrodywAAAABJRU5ErkJggg==
"@

$picError = @"
iVBORw0KGgoAAAANSUhEUgAAABIAAAATCAYAAACdkl3yAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xMzQDW3oAAAIkSURBVDhPrVNLTxNRGOX3yMMIPnioUQGr1MRHUsWVqNGkmFilLmxdkuiuUPesoAkLNQ4B9pi2c8d2mqYPysbEX0BqwkrF4z1fue
MMUxYab3KSb86c79zvMdMD4L+gK0lYHy1kF7NIp9ICxuQO6wxCxJq1hmz2Ld69/4BPW1twy2UBY3J8R83hvMBDbiWH5eUVOJubaOgKtlMptJIvBIxrmQWojQ3RUOvP9QLeQkF1dRVNnbiTTGLn+Rx+7u0Jvi4sopV4hqbm3FznQn9lnhFLZiXNuSRaTxPYjs+i8egxhXK+zM+jfm8GjQcPUZt9ArW+Lm3q88eIQ2T/tUwGzXgc9Zn7
qN6ZRuX6DQrlkC9NXoZ7dUr4yus3kmMW0KlGz4PDrCcSYuBGo/h84SLUyChFcqqxGIqDQ7BPnRa+NH1XcpirT8eI6+VmKrHbKF0ahzozjOKJQRT6B/Brf59CuFNR5Pv6BeSLwyOSw1x6BIyciUnYQydRGDiOfG8f8sd6gQOj0viEPHvQupCRac25eUvfpm89MCHaSuGb68I5dz5gZEevhVszw3bSrwImhBodgzN2ttOWj3d0JaFhE1
xl0bJgRyKBBHPKkSseZ+u4oLWh9RPmg1RLSwGz77u7+NFuezOiCTVHfpCE+UV4m3qZkjnk9coJxmyH76g58hcx4C0smf1zmNwMwZgc3/krMQg8+MEhciNcL8HYDLYbupL/gq7k3wM9vwHRp84v4jR7bgAAAABJRU5ErkJggg==
"@

$picWarning = @"
iVBORw0KGgoAAAANSUhEUgAAABIAAAARCAYAAADQWvz5AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xMzQDW3oAAAGsSURBVDhPrY9LLwNhGIX7DyTUtEJIG627CBIL102jSAhbf8CWv2DrhyjCykK6cKkWrRJEhUaIltC4zHRmWtrFMe836UfbQYLFM/
PN+d73nDMmAP+CofiZgxUniEK9EEMxx/FqF07XbLgMNIPOhfefMRRzBOfNkG5dUB9HEPKUa5LxHGEoEtQg4q1FVp1g/NTKUCSCHjPkezc3Sj1938pQpOTzdSeyqUltwsTQW7V82apIIChZSQwhq4xzo0xyDKmE+8tWRQIlRrcakJXHkJFGP4xehhlXgSbDVnkfRGhB0JIHkRFH8PY8xI3eEi6GejsAmincy/ugJEp8vetHOt6HdKwX
01NVjPRNt06sB9c7jUWt+CF2NIvwkgVKtBPqeRvUsxYokWaGetaqa0S0HfJFB2tFO0VGlBAPOCEfOZEM25AM1SAZrOa/Joft7E45roNyUo+Y35HXij2uQjM4XLZqBnZIu5WQ/FZI2wJEn8CNpEAFuyNzQtq3IbwogHa5ETk/7DnYsLhVDnGzDOJGqf7mmPU7HyFoQRbEfTbeihlFvG545kp+Be1yo78D0zvkR2LiNXzWCAAAAABJRU
5ErkJggg==
"@

$picInformation = @"
iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwgAADsIBFShKgAAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xMzQDW3oAAAJUSURBVDhPrVNLaxNRGO3alZtuKooLXbh3IXThi7oQF4LgXqE/wP6DCnajC2mqxLYgVAehi6qBCDWQYGNM82gek6R5TWgeNkNMs6g
lJJLHcc5XJiaduBC8cODOne8793znzEwA+C8Ye0gobxUsPFnA3KM5Afc8O1lnwnKgKArm5x/j1fIynE4ngsGggHue8R1rTvaNPNjtdiwu2pDNZtFsNtHr9dDv99HtdtFqtVCv16GqqtSwdrh3sOEtLKjVatLM5fDs4cyNNZy9uYajo59oNBrQqzoy6bRRuzSibEBEyVRiknBtuDScurwiODBIqtUqiqUi8rkc/H6/jGmsP0Q0kfNzHC
5znGazhVLlANqeDl3XUSwWjctySCQSiER2pMcMQIiYCM0c9uRXu42Nzxlcf/ABM7MOFAoFpFIpgyAiajwej/Swd0DEeJkMSTqdjhh7eHgIxaHi9PQbTF59h2QyKSSBQABerxcul0t62GshopK2oYQkNH11PYzJa+uYmnkvaUWiUanz+Xxwu91WInM0UwlJyuUyXirbmLr1EedufxJfiHg8jqihbNsYzzKaafYP4zsxSTQtj+evv+L8n
U1cuOtGOpNBzkgrn89LuiS0mE0wSsovl0pSvJtK4tnqFi7e+4JL97+J2Uyt8r0iF4XDYWv8BD8um+2FkcyujBCLxfB0ZQtXHgYwPbsjzVS7X92Xi1g79oMkjn+RJYk3FAqJmWpChWY0Ho+riRKS/PUXMcFbKJnz00ySEdzzjO+GlZgYeRgGTWQijJfg3jR2HMYe/jsw8RuiSe+Il8ZhiAAAAABJRU5ErkJggg==
"@

Function WriteToImageFile
{
param($base64string, [string]$filepath)
if(!(Test-Path $filepath))
{
    $bytes = [convert]::FromBase64String($base64string)
    [IO.File]::WriteAllBytes($filepath,$bytes)
}
}

WriteToImageFile $picCritical $env:TEMP\Critical.png
WriteToImageFile $picError $env:TEMP\Error.png
WriteToImageFile $picWarning $env:TEMP\Warning.png
WriteToImageFile $picInformation $env:TEMP\Information.png

#==========================================================================
# Function		: PingHost 
# Arguments     : host, timeout
# Returns   	: boolean
# Description   : Ping a host and returns results in form of boolean
# 
#==========================================================================
Function PingHost {
    param([Array]$hostlist,[Array]$ports,[Int]$timeout = "1")
    $ErrorActionPreference = "SilentlyContinue"
    $ping = new-object System.Net.NetworkInformation.Ping
    foreach ($ip in $hostlist)
    {
        $rslt = $ping.send($ip,$timeout)
        if (! $?)
        {
            return $false
        }
        else
        {
            return $true
        }
    }

}

#==========================================================================
# Function		: PortPing 
# Arguments     : host, port timeout
# Returns   	: boolean
# Description   : Ping a port number and returns results in form of boolean
# 
#==========================================================================
Function PortPing
{
Param([string]$srv,$port=135,$timeout=3000,[switch]$verbose)

# Test-Port.ps1
# Does a TCP connection on specified port (135 by default)

$ErrorActionPreference = "SilentlyContinue"

# Create TCP Client
$tcpclient = new-Object system.Net.Sockets.TcpClient

# Tell TCP Client to connect to machine on Port
$iar = $tcpclient.BeginConnect($srv,$port,$null,$null)

# Set the wait time
$wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)

# Check to see if the connection is done
if(!$wait)
{
    # Close the connection and report timeout
    $tcpclient.Close()
    if($verbose){Write-Host "Connection Timeout"}
    Return $false
}
else
{
    # Close the connection and report the error if there is one
    $error.Clear()
    $tcpclient.EndConnect($iar) | out-Null
    if(!$?){if($verbose){write-host $error[0]};$failed = $true}
    $tcpclient.Close()
}

# Return $true if connection Establish else $False
if($failed){return $false}else{return $true}
}
#==========================================================================
# Function		: LogMessage 
# Arguments     : Type of message, message, date stamping
# Returns   	: Custom psObject with two properties, type and message
# Description   : This function creates a custom object that is used as input to an ListBox for logging purposes
# 
#==========================================================================
function LogMessage 
{ 
     param ( 
         [Parameter(  
             Mandatory = $true
          )][String[]] $strType ,
        
        [Parameter(  
             Mandatory = $true 
          )][String[]]  $strMessage ,

       [Parameter(  
             Mandatory = $false
         )][switch]$DateStamp
     )
     
     process {

                if ($DateStamp)
                {

                    $newMessageObject = New-Object PSObject -Property @{Type="$strType";Message="[$(get-date -uformat %H:%M:%S)] $strMessage"}
                }
                else
                {

                    $newMessageObject = New-Object PSObject -Property @{Type="$strType";Message="$strMessage"}
                }

         
                return $newMessageObject
            }
 } 


$xamlBase =@"
<Window x:Class="WpfApplication1.PCRVS"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication1"

        Title="XPathStudio" WindowStartupLocation="CenterScreen" Height="500" Width="1023" ResizeMode="CanResizeWithGrip" WindowState="Maximized"  >
        <ScrollViewer HorizontalScrollBarVisibility="Auto" VerticalScrollBarVisibility="Auto">
        <Grid Background="white">
        <StackPanel Orientation="Vertical" >
        <StackPanel Orientation="Horizontal" >
        <Label x:Name="lblXPath" Margin="0,0,0,0"  Content="XPath Filter:" FontWeight="Bold"  FontSize="14"  HorizontalAlignment="Left" Foreground="#000000"/>
        <Label x:Name="lblAuthor" Content="Author:Robin Granberg"  HorizontalAlignment="Right" VerticalAlignment="Bottom" Foreground="#000000"/>
        </StackPanel>
        <TextBox x:Name="txtBoxXML" Margin="0,0,0,0"  Text="" FontWeight="Normal" Width="900" Height="150" FontSize="14"  HorizontalAlignment="LEft" Foreground="#00FF00" Background="Black" TextWrapping="WrapWithOverflow" AcceptsReturn="True" VerticalScrollBarVisibility="Visible" />
        <StackPanel Orientation="Horizontal" >
            <GroupBox x:Name="gBoxHost" Header="Host" Height="152">
                <StackPanel Orientation="Vertical" >
                    <TextBox x:Name="txtBoxHosts" Margin="0,5,0,0"  Text="LocalHost" FontWeight="Normal" Width="230" Height="70" FontSize="14"  VerticalAlignment="Top" Foreground="#000000" TextWrapping="Wrap" AcceptsReturn="True" VerticalScrollBarVisibility="Visible" HorizontalScrollBarVisibility="Visible" ScrollViewer.CanContentScroll="True" />
                    <CheckBox x:Name="chkBpxDC" Content="Domain Controllers" HorizontalAlignment="Left" Height="18" Margin="5,10,0,0" VerticalAlignment="Top" Width="190" IsChecked="False"/>
                    <StackPanel Orientation="Horizontal" >
                        <Label x:Name="lblMaxEvent" Margin="0,0,5,0"  Content="Max Returned Events:" FontWeight="Normal"   FontSize="12"  VerticalAlignment="Center" Foreground="#000000"/>
                        <TextBox x:Name="txtMaxEvent" Margin="0,5,0,0"  Text="100" FontWeight="Normal" Width="45" Height="20" FontSize="12"  VerticalAlignment="Top" Foreground="#000000" />
                    </StackPanel>
                </StackPanel>
            </GroupBox>
            <TabControl x:Name="tabFilter" HorizontalAlignment="Left" Height="152" Margin="10,0,0,0" VerticalAlignment="Top" Width="580">
            <TabItem x:Name="tabNJSON" Header="xample Queries from xpathfilter.json" Height="22" VerticalAlignment="Top" >
            <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="160">
            <StackPanel Orientation="Vertical">
            <DataGrid x:Name="dgJSONInput" HorizontalAlignment="Left" Margin="0,0,0,0" Width="570"  Height="120" GridLinesVisibility="All" AlternatingRowBackground="Lightblue" AlternationCount="2" IsReadOnly="True" FontSize="12" VerticalScrollBarVisibility="Visible" >
                <DataGrid.Columns>
                <DataGridTextColumn Header='Filter' Binding='{Binding Filter}' Width='410' />
                <DataGridTextColumn Header='Category' Binding='{Binding Category}' Width='100' />
                <DataGridTextColumn Header='XPath' Binding='{Binding XPath}' Width='80' Visibility="Collapsed" />
                </DataGrid.Columns>
            </DataGrid>
            </StackPanel>
            </Grid>
            </TabItem>
            <TabItem x:Name="tabSyntax" Header="Syntax Support" Height="22" VerticalAlignment="Top">
            <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="160">
            <StackPanel Orientation="Vertical">
                    <DataGrid x:Name="dgSyntax" HorizontalAlignment="Left" Margin="0,0,0,0" Height="120" Width="580" GridLinesVisibility="All" AlternatingRowBackground="Lightblue" AlternationCount="2" IsReadOnly="True" FontSize="12" VerticalScrollBarVisibility="Visible" >
                        <DataGrid.Resources>
                            <Style TargetType='DataGridCell'>
                                <Style.Triggers>
                                    <Trigger Property='DataGridCell.IsSelected' Value="True">
                                        <Setter Property="Background" Value='{x:Null}' />
                                        <Setter Property="BorderBrush" Value='{x:Null}' />
                                        <Setter Property="Foreground" Value='Black' />
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </DataGrid.Resources>
                        <DataGrid.Columns>
                            <DataGridTextColumn Header='Data' Binding='{Binding Data}' Width='230'  />
                            <DataGridTemplateColumn Header='Example' Width='325'>
                                <DataGridTemplateColumn.CellTemplate>
                                    <DataTemplate>
                                        <TextBox Text='{Binding Example}' BorderBrush='{x:Null}' Background='{x:Null}' />
                                     </DataTemplate>
                                </DataGridTemplateColumn.CellTemplate>
                            </DataGridTemplateColumn>
                        </DataGrid.Columns>
                    </DataGrid>
            </StackPanel>
            </Grid>
            </TabItem>
            </TabControl>
            <GroupBox x:Name="gBoxStatus" Header="Log:" Height="150" Margin="0,0,0,0" VerticalAlignment="Top">
              <ListBox x:Name="TextBoxStatusMessage" DisplayMemberPath="Message" SelectionMode="Extended" HorizontalAlignment="Left" Height="130" Margin="0,0,0,0" VerticalAlignment="Top" Width="360" ScrollViewer.HorizontalScrollBarVisibility="Auto">
                    <ListBox.ItemContainerStyle>
                        <Style TargetType="{x:Type ListBoxItem}">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Type}" Value="Error">
                                    <Setter Property="ListBoxItem.Foreground" Value="Red" />
                                    <Setter Property="ListBoxItem.Background" Value="LightGray" />
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Type}" Value="Warning">
                                    <Setter Property="ListBoxItem.Foreground" Value="Yellow" />
                                    <Setter Property="ListBoxItem.Background" Value="Gray" />
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Type}" Value="Info">
                                    <Setter Property="ListBoxItem.Foreground" Value="Black" />
                                    <Setter Property="ListBoxItem.Background" Value="White" />
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </ListBox.ItemContainerStyle>
                </ListBox>
                </GroupBox>
                <GroupBox x:Name="gBoxDisplayfilter" Header="Display filter" Height="150" Margin="0,0,0,0" VerticalAlignment="Top">
                <StackPanel Orientation="Vertical" >
                    <CheckBox x:Name="chkBoxDisplayFilter" Content="Use Display filter" HorizontalAlignment="Left" Height="18" Margin="0,5,0,0" VerticalAlignment="Top" Width="190" IsChecked="False"/>
                    <StackPanel Orientation="Horizontal" >
                        <Label x:Name="lblProp" Margin="0,0,0,0"  Content="Property:"  FontSize="12"  HorizontalAlignment="LEft" Foreground="#000000" Width="80"/>
                        <TextBox x:Name="txtProp" Margin="0,0,0,0"  Text="" FontWeight="Normal" Width="200" Height="20" FontSize="12" IsEnabled="False"  />
                    </StackPanel>
                   <StackPanel Orientation="Horizontal" >
                        <Label x:Name="lblOperator" Margin="0,0,0,0"  Content="Operator:"  FontSize="12"  HorizontalAlignment="LEft" Foreground="#000000" Width="80"/>
                        <ComboBox x:Name="lbOperator" Margin="0,0,0,0" VerticalAlignment="Top" Width="90" IsEnabled="False"/>
                    </StackPanel>
                    <StackPanel Orientation="Horizontal" >
                        <Label x:Name="lblString" Margin="0,0,0,0"  Content="Value:"   FontSize="12"  HorizontalAlignment="LEft" Width="80"/>
                        <TextBox x:Name="txtString" Margin="0,0,0,0"  Text="" FontWeight="Normal" Width="200" Height="20" FontSize="12" Foreground="#000000" IsEnabled="False" />
                    </StackPanel>
                    <StackPanel Orientation="Horizontal" >
                        <Button x:Name="btnApplyDisplayfilter" Content="Apply" HorizontalAlignment="Center" Margin="0,0,0,0" VerticalAlignment="Top" Width="100" IsEnabled="False"/>
                        <Button x:Name="btnClearDisplayfilter" Content="Clear" HorizontalAlignment="Center" Margin="0,0,0,0" VerticalAlignment="Top" Width="100" IsEnabled="False"/>
                    </StackPanel>
                </StackPanel>
                </GroupBox>
        </StackPanel >
        <StackPanel Orientation="Horizontal" >
        <Button x:Name="btnExit" Content="Exit" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="btnRun" Content="Run" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="btnReload" Content="Reload JSON file" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="100"/>
        </StackPanel>
        <TabControl x:Name="tabViews" HorizontalAlignment="Left" Height="600" Margin="10,10,0,0" VerticalAlignment="Top" Width="755">
        <TabItem x:Name="tabNormal" Header="Standard" Height="22" VerticalAlignment="Top" >
        <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="570">
        <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
        <Label x:Name="lblEventID" Margin="0,0,0,0"  Content="Event IDs:" FontWeight="Bold"   FontSize="14"  HorizontalAlignment="LEft" Foreground="#000000"/>
            <Button x:Name="btnExportStandard" Content="Export CSV" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
            <Button x:Name="btnExportStandardExcel" Content="Export Excel" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        </StackPanel>
            <DataGrid x:Name="dgEventIDs" HorizontalAlignment="Left" Margin="0,0,0,10" Width="750"  MaxHeight="500" GridLinesVisibility="None" AlternationCount="2" IsReadOnly="True" FontSize="12">
                <DataGrid.RowStyle>
                    <Style TargetType="DataGridRow"> 
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding hidden}" Value="True">
                                <Setter Property="Visibility" Value="Collapsed"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.RowStyle>
                <DataGrid.Resources>
                    <Style TargetType="TextBox">
                        <Style.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.Resources>            
            <DataGrid.Columns>
                <DataGridTextColumn Header='Computer' Binding='{Binding MachineName}' Width='80' />
                <DataGridTemplateColumn Header='Level' SortMemberPath='Level'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate >
                            <StackPanel Orientation='Horizontal' >
                                <Image Name='IsReadImage' Source='file:///$($env:TEMP)\Information.png' VerticalAlignment='Top' />
                                <TextBlock Text='{Binding LevelDisplayName}' />
                            </StackPanel>
                                <DataTemplate.Triggers>
                                        <DataTrigger Binding='{Binding Level}' Value='1' >
                                            <Setter TargetName='IsReadImage' Property='Source' Value='file:///$($env:TEMP)\Critical.png' />
                                        </DataTrigger>
                                        <DataTrigger Binding='{Binding Level}' Value='2' >
                                            <Setter TargetName='IsReadImage' Property='Source' Value='file:///$($env:TEMP)\Error.png' />
                                        </DataTrigger>
                                        <DataTrigger Binding='{Binding Level}' Value='3' >
                                            <Setter TargetName='IsReadImage' Property='Source' Value='file:///$($env:TEMP)\Warning.png' />
                                        </DataTrigger>
                                </DataTemplate.Triggers>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Date and Time' Binding='{Binding TimeCreated, StringFormat=\{0:yyyy-MM-dd HH:mm:ss\}}' Width='SizeToCells' />
                <DataGridTextColumn Header='Event ID' Binding='{Binding Id}' Width='65' />
                <DataGridTextColumn Header='Source' Binding='{Binding ProviderName}' Width='120' />
                <DataGridTemplateColumn Header='Message' Width='*' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Message}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
              </DataGrid.Columns>
            </DataGrid>
        </StackPanel>                                
        </Grid>
        </TabItem>
        <TabItem x:Name="tabFW" Header="Firewall View" Height="22" VerticalAlignment="Top"  >
        <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="570">
        <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
            <Label x:Name="lblfw" Margin="0,0,0,0"  Content="FW Event IDs:" FontWeight="Bold"   FontSize="14"  HorizontalAlignment="LEft" Foreground="#000000"/>
            <Button x:Name="btnExportFW" Content="Export CSV" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
            <Button x:Name="btnExportFWExcel" Content="Export Excel" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        </StackPanel>
            <DataGrid x:Name="dgFWEventIDs" HorizontalAlignment="Left" Margin="0,0,0,10" Width="750"  MaxHeight="500" GridLinesVisibility="None" AlternationCount="2" IsReadOnly="True" FontSize="12">
                <DataGrid.RowStyle>
                    <Style TargetType="DataGridRow"> 
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding hidden}" Value="True">
                                <Setter Property="Visibility" Value="Collapsed"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.RowStyle>
            <DataGrid.Resources>
                <Style TargetType='DataGridCell'>
                    <Style.Triggers>
                        <Trigger Property='DataGridCell.IsSelected' Value="True">
                            <Setter Property="Background" Value='{x:Null}' />
                            <Setter Property="BorderBrush" Value='{x:Null}' />
                            <Setter Property="Foreground" Value='Black' />
                        </Trigger>
                    </Style.Triggers>
                </Style>
            </DataGrid.Resources>
            <DataGrid.Columns>
                <DataGridTemplateColumn Header='MachineName' Width='80' SortMemberPath='MachineName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding MachineName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='TimeCreated' Width='SizeToCells' SortMemberPath='TimeCreated' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TimeCreated, StringFormat=\{0:yyyy-MM-dd HH:mm:ss\}}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Action' Binding='{Binding Id}' Width='65' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5152">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Blocked" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5157">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Blocked" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5156">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Accepted" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>                
                <DataGridTextColumn Header='Direction' Binding='{Binding Direction}' Width='65' SortMemberPath='Direction' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Direction}" Value="%%14592">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Inbound" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Direction}" Value="%%14593">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="OutBound" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>
                <DataGridTemplateColumn Header='SourceAddress' Width='70' SortMemberPath='SourceAddress' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourceAddress}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>    
                <DataGridTemplateColumn Header='SourcePort' Width='65' SortMemberPath='SourcePort' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourcePort}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>                              
                <DataGridTemplateColumn Header='DestAddress' Width='70' SortMemberPath='DestAddress' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestAddress}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='DestPort' Width='70' SortMemberPath='DestPort' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestPort}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Protocol' Binding='{Binding Protocol}' Width='65' SortMemberPath='Protocol' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Protocol}" Value="6">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="TCP"  BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Protocol}" Value="17">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="UDP"  BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>
                <DataGridTemplateColumn Header='Application' Width='400' SortMemberPath='Application'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Application}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
              </DataGrid.Columns>
            </DataGrid>
        </StackPanel> 
        </Grid>
        </TabItem>
        <TabItem x:Name="tabLogon" Header="Logon View" Height="22" VerticalAlignment="Top"  >
        <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="570">
        <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
            <Label x:Name="lbllogon" Margin="0,0,0,0"  Content="Logon Event IDs:" FontWeight="Bold"   FontSize="14"  HorizontalAlignment="LEft" Foreground="#000000"/>
            <Button x:Name="btnExportLogon" Content="Export CSV" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
            <Button x:Name="btnExportLogonExcel" Content="Export Excel" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        </StackPanel>
            <DataGrid x:Name="dgLogonIDs" HorizontalAlignment="Left" Margin="0,0,0,10" Width="750"  MaxHeight="500" GridLinesVisibility="None" AlternationCount="2" IsReadOnly="True" FontSize="12">
                <DataGrid.RowStyle>
                    <Style TargetType="DataGridRow"> 
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding hidden}" Value="True">
                                <Setter Property="Visibility" Value="Collapsed"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.RowStyle>
                <DataGrid.Resources>
                    <Style TargetType="TextBox">
                        <Style.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.Resources>   
            <DataGrid.Columns>
                <DataGridTemplateColumn Header='MachineName' Width='100' SortMemberPath='MachineName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding MachineName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='TimeCreated' Width='SizeToCells' SortMemberPath='TimeCreated' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TimeCreated, StringFormat=\{0:yyyy-MM-dd HH:mm:ss\}}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Action' Binding='{Binding Id}' Width='SizeToCells' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4672">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Special Logon" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4624">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Logon" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4648">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Logon" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4634">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Logoff" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4647">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Logoff" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4964">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Special Logon" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>                
                <DataGridTemplateColumn Header='LogonType' Width='SizeToCells' SortMemberPath='LogonType' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding LogonType}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='TargetUserSid' Width='SizeToCells' SortMemberPath='TargetUserSid' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TargetUserSid}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='TargetUserName' Width='SizeToCells' SortMemberPath='TargetUserName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TargetUserName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>    
                <DataGridTemplateColumn Header='TargetDomainName' Width='SizeToCells' SortMemberPath='TargetDomainName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TargetDomainName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>                              
                <DataGridTemplateColumn Header='ProcessID' Width='SizeToCells' SortMemberPath='ProcessID' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ProcessID}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='ProcessName' Width='SizeToCells' SortMemberPath='ProcessName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ProcessName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='SubjectUserSid' Width='SizeToCells' SortMemberPath='SubjectUserSid' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SubjectUserSid}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='SubjectUserName' Width='SizeToCells' SortMemberPath='SubjectUserName'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SubjectUserName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='SubjectDomainName' Width='SizeToCells' SortMemberPath='SubjectDomainName'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SubjectDomainName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='SubjectLogonID' Width='SizeToCells' SortMemberPath='SubjectLogonID'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SubjectLogonID}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='IpAddress' Width='SizeToCells' SortMemberPath='IpAddress'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding IpAddress}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='IpPort' Width='SizeToCells' SortMemberPath='IpPort'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding IpPort}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='SidList' Width='SizeToCells' SortMemberPath='SidList'>
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SidList}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
              </DataGrid.Columns>
            </DataGrid>
        </StackPanel> 
        </Grid>
        </TabItem>
        <TabItem x:Name="tabSysmon" Header="Sysmon View" Height="22" VerticalAlignment="Top"  >
        <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="570">
        <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
        <Label x:Name="lblSysmon" Margin="0,0,0,0"  Content="Sysmon Event IDs:" FontWeight="Bold"   FontSize="14"  HorizontalAlignment="LEft" Foreground="#000000"/>
        <Button x:Name="btnExportSysmon" Content="Export CSV" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="btnExportSysmonExcel" Content="Export Excel" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        </StackPanel>
            <DataGrid x:Name="dgSysmonIDs" HorizontalAlignment="Left" Margin="0,0,0,10" Width="750"  MaxHeight="500" GridLinesVisibility="None" AlternationCount="2" IsReadOnly="True" FontSize="12">
            <DataGrid.RowStyle>
                <Style TargetType="DataGridRow"> 
                    <Style.Triggers>
                        <DataTrigger Binding="{Binding hidden}" Value="True">
                            <Setter Property="Visibility" Value="Collapsed"/>
                        </DataTrigger>
                    </Style.Triggers>
                </Style>
            </DataGrid.RowStyle>
                <DataGrid.Resources>
                    <Style TargetType="TextBox">
                        <Style.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.Resources>   
            <DataGrid.Columns>
                <DataGridTemplateColumn Header='MachineName' Width='100' SortMemberPath='MachineName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding MachineName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='TimeCreated' Width='SizeToCells' SortMemberPath='TimeCreated' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TimeCreated, StringFormat=\{0:yyyy-MM-dd HH:mm:ss\}}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='Event Id' Width='SizeToCells' SortMemberPath='Id' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Id}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Category' Binding='{Binding Id}' Width='SizeToCells' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Id}" Value="1">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Process Create" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="2">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="File creation time changed" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="3">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Network connection detected" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="4">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Sysmon service state changed" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="File creation time changed" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="6">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Driver loaded" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="7">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Image loaded" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="11">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="File created" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="17">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Pipe Created" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="18">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Pipe Connected" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>   
                <DataGridTemplateColumn Header='RuleName' Width='SizeToCells' SortMemberPath='RuleName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding RuleName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='UtcTime' Width='SizeToCells' SortMemberPath='UtcTime' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding UtcTime}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ProcessGuid' Width='SizeToCells' SortMemberPath='ProcessGuid' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ProcessGuid}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ProcessId' Width='SizeToCells' SortMemberPath='ProcessId' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ProcessId}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Image' Width='SizeToCells' SortMemberPath='Image' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Image}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='FileVersion' Width='SizeToCells' SortMemberPath='FileVersion' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding FileVersion}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Description' Width='SizeToCells' SortMemberPath='Description' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Description}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Product' Width='SizeToCells' SortMemberPath='Product' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Product}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Company' Width='SizeToCells' SortMemberPath='Company' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Company}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='CommandLine' Width='SizeToCells' SortMemberPath='CommandLine' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding CommandLine}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='CurrentDirectory' Width='SizeToCells' SortMemberPath='CurrentDirectory' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding CurrentDirectory}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='User' Width='SizeToCells' SortMemberPath='User' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding User}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='LogonGuid' Width='SizeToCells' SortMemberPath='LogonGuid' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding LogonGuid}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='LogonId' Width='SizeToCells' SortMemberPath='LogonId' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding LogonId}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='TerminalSessionId' Width='SizeToCells' SortMemberPath='TerminalSessionId' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TerminalSessionId}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='IntegrityLevel' Width='SizeToCells' SortMemberPath='IntegrityLevel' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding IntegrityLevel}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Hashes' Width='SizeToCells' SortMemberPath='Hashes' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Hashes}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ParentProcessGuid' Width='SizeToCells' SortMemberPath='ParentProcessGuid' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ParentProcessGuid}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ParentProcessId' Width='SizeToCells' SortMemberPath='ParentProcessId' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ParentProcessId}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ParentImage' Width='SizeToCells' SortMemberPath='ParentImage' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ParentImage}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ParentCommandLine' Width='SizeToCells' SortMemberPath='ParentCommandLine' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ParentCommandLine}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Protocol' Width='SizeToCells' SortMemberPath='Protocol' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Protocol}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Initiated' Width='SizeToCells' SortMemberPath='Initiated' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Initiated}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SourceIsIpv6' Width='SizeToCells' SortMemberPath='SourceIsIpv6' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourceIsIpv6}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SourceIp' Width='SizeToCells' SortMemberPath='SourceIp' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourceIp}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SourceHostname' Width='SizeToCells' SortMemberPath='SourceHostname' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourceHostname}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SourcePort' Width='SizeToCells' SortMemberPath='SourcePort' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourcePort}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SourcePortName' Width='SizeToCells' SortMemberPath='SourcePortName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SourcePortName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='DestinationIsIpv6' Width='SizeToCells' SortMemberPath='DestinationIsIpv6' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestinationIsIpv6}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='DestinationIp' Width='SizeToCells' SortMemberPath='DestinationIp' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestinationIp}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='DestinationHostname' Width='SizeToCells' SortMemberPath='DestinationHostname' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestinationHostname}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='DestinationPort' Width='SizeToCells' SortMemberPath='DestinationPort' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestinationPort}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='DestinationPortName' Width='SizeToCells' SortMemberPath='DestinationPortName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding DestinationPortName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='ImageLoaded' Width='SizeToCells' SortMemberPath='ImageLoaded' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ImageLoaded}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Signed' Width='SizeToCells' SortMemberPath='Signed' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Signed}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Signature' Width='SizeToCells' SortMemberPath='Signature' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Signature}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='SignatureStatus' Width='SizeToCells' SortMemberPath='SignatureStatus' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding SignatureStatus}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='EventType' Width='SizeToCells' SortMemberPath='EventType' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding EventType}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='TargetObject' Width='SizeToCells' SortMemberPath='TargetObject' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TargetObject}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='Details' Width='SizeToCells' SortMemberPath='Details' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Details}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='NewName' Width='SizeToCells' SortMemberPath='NewName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding NewName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                
              </DataGrid.Columns>
            </DataGrid>
        </StackPanel> 
        </Grid>
        </TabItem>          
        <TabItem x:Name="tabGPO" Header="Group Policy View" Height="22" VerticalAlignment="Top"  >
        <Grid Background="AliceBlue" HorizontalAlignment="Left" VerticalAlignment="Top" Height="570">
        <StackPanel Orientation="Vertical">
        <StackPanel Orientation="Horizontal">
        <Label x:Name="lblGPO" Margin="0,0,0,0"  Content="Group Policy Event IDs:" FontWeight="Bold"   FontSize="14"  HorizontalAlignment="LEft" Foreground="#000000"/>
        <Button x:Name="btnExportGPO" Content="Export CSV" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="btnExportGPOExcel" Content="Export Excel" HorizontalAlignment="Center" Margin="50,0,0,0" VerticalAlignment="Top" Width="75"/>
        </StackPanel>
            <DataGrid x:Name="dgGPOIDs" HorizontalAlignment="Left" Margin="0,0,0,10" Width="750"  MaxHeight="500" GridLinesVisibility="None" AlternationCount="2" IsReadOnly="True" FontSize="12">
            <DataGrid.RowStyle>
                <Style TargetType="DataGridRow"> 
                    <Style.Triggers>
                        <DataTrigger Binding="{Binding hidden}" Value="True">
                            <Setter Property="Visibility" Value="Collapsed"/>
                        </DataTrigger>
                    </Style.Triggers>
                </Style>
            </DataGrid.RowStyle>
                <DataGrid.Resources>
                    <Style TargetType="TextBox">
                        <Style.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </DataGrid.Resources>   
            <DataGrid.Columns>
                <DataGridTemplateColumn Header='MachineName' Width='100' SortMemberPath='MachineName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding MachineName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
            <DataGridTemplateColumn Header='TimeCreated' Width='SizeToCells' SortMemberPath='TimeCreated' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding TimeCreated, StringFormat=\{0:yyyy-MM-dd HH:mm:ss\}}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTemplateColumn Header='Event Id' Width='SizeToCells' SortMemberPath='Id' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding Id}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
                <DataGridTextColumn Header='Category' Binding='{Binding Id}' Width='SizeToCells' >
                    <DataGridTextColumn.CellStyle>
                        <Style TargetType="DataGridCell">
                            <Style.Triggers>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5136">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Modified" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5137">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Created" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5138">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Undeleted" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                                <DataTrigger Binding="{Binding Path=Id}" Value="5141">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="DataGridCell">
                                                    <TextBox Text="Deleted" BorderBrush='{x:Null}' Background='{x:Null}'/>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </DataTrigger>
                            </Style.Triggers>
                        </Style>
                    </DataGridTextColumn.CellStyle>
                </DataGridTextColumn>  
                <DataGridTemplateColumn Header='User' Width='SizeToCells' SortMemberPath='User' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding User}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>                   
                <DataGridTemplateColumn Header='GPO Name' Width='SizeToCells' SortMemberPath='GPO Name' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding GPO Name}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='GUID' Width='SizeToCells' SortMemberPath='GUID' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding GUID}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='OjbectClass' Width='SizeToCells' SortMemberPath='ObjectClass' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding ObjectClass}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
                <DataGridTemplateColumn Header='AttributeLDAPDisplayName' Width='SizeToCells' SortMemberPath='AttributeLDAPDisplayName' >
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBox Text='{Binding AttributeLDAPDisplayName}' BorderBrush='{x:Null}' Background='{x:Null}' />
                            </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>  
              </DataGrid.Columns>
            </DataGrid>
        </StackPanel> 
        </Grid>
        </TabItem>                    
        </TabControl>
        </StackPanel>
    </Grid>
    </ScrollViewer>
</Window>
"@

#Replace x:Name to XML variable Name
$xamlBase = $xamlBase.Replace("x:Name","Name")
[XML] $XAML = $xamlBase
$xaml.Window.RemoveAttribute("x:Class")  
  
$reader=(New-Object System.Xml.XmlNodeReader $XAML)
$Window=[Windows.Markup.XamlReader]::Load( $reader )

#Search the XML data for object and create variables
$XAML.SelectNodes("//*[@Name]")| %{set-variable -Name ($_.Name) -Value $Window.FindName($_.Name)}

$Window.Add_Loaded({
    $Global:observableCollection = New-Object System.Collections.ObjectModel.ObservableCollection[System.Object]
    $TextBoxStatusMessage.ItemsSource = $Global:observableCollection
})


[System.Windows.RoutedEventHandler]$clickEvent = {
param ($sender,$e)
$strXPath = $($dgJSONInput.SelectedItem.XPath)
$arrXPath = $strXPath.split("<")
$strXPathBox = ""
for ($i=1; $i -lt @($arrXPath).count ;$i++)
{
    if($strXPathBox -ne "")
    {
        if($strXPathBox.Substring($strXPathBox.Length-1,1) -ne ">")
        {
            $strXPathBox = $strXPathBox + "<" + $arrXPath[$i].Trim()
        }
        else
        {
            $strXPathBox = $strXPathBox + "`n" + "<" + $arrXPath[$i].Trim() 
        }
    }
    else
    {
        $strXPathBox = $strXPathBox + "<" + $arrXPath[$i].Trim() 
    }
}
$txtBoxXML.Text = $strXPathBox
    
}

$buttonColumn = New-Object System.Windows.Controls.DataGridTemplateColumn
$buttonFactory = New-Object System.Windows.FrameworkElementFactory([System.Windows.Controls.Button])
$buttonFactory.SetValue([System.Windows.Controls.Button]::ContentProperty, "Load")
$buttonFactory.AddHandler([System.Windows.Controls.Button]::ClickEvent,$clickEvent)
$dataTemplate = New-Object System.Windows.DataTemplate
$dataTemplate.VisualTree = $buttonFactory
$buttonColumn.CellTemplate = $dataTemplate
$dgJSONInput.Columns.Add($buttonColumn)


if(Test-Path $JSONFile)
{
    $JSON = (Get-Content $JSONFile | Select-String -Pattern "//" -NotMatch) -join "`n" | ConvertFrom-Json 
    ## Add all XPath Objects in DataGridView
    foreach($Query in $JSON.Queries)
    {
        $objXMLQuery = New-Object PSObject
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "Filter" -value $Query.Name
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "Category" -value $Query.Category
        $strQuery = "<!--- Name:" + $Query.Name + " -->" + $Query.Query
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "XPath" -value  $strQuery 
        [VOID]$dgJSONInput.AddChild($objXMLQuery)
    }
}

[VOID]$lboperator.Items.Add("LIKE")
[VOID]$lboperator.Items.Add("EQ")
[VOID]$lboperator.Items.Add("NE")
[VOID]$lboperator.Items.Add("NOTLIKE")

### BUILD SYNTAX HELP LEGEND
$SyntaxHelpObj = New-Object System.Collections.ArrayList

## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACELOG"
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value "Security"

[VOID]$SyntaxHelpObj.Add($objSyntax)

## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACELOG"
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value "Microsoft-Windows-PowerShell/Operational"

[VOID]$SyntaxHelpObj.Add($objSyntax)


## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACEID"
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value "6008"

[VOID]$SyntaxHelpObj.Add($objSyntax)

## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACEUSERNAME"
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value "jsmith01"

[VOID]$SyntaxHelpObj.Add($objSyntax)

## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACEDATE"
$xpathdate  = (get-date -UFormat %Y-%m-%dT%H:%M:%S.000Z)
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value $xpathdate

[VOID]$SyntaxHelpObj.Add($objSyntax)

## Syntax Object to put in DataGrid
$objSyntax = New-Object PSObject
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Data" -value "REPLACEIP"
Add-Member -inputObject $objSyntax -memberType NoteProperty -name "Example" -value "192.168.0.20"

[VOID]$SyntaxHelpObj.Add($objSyntax)


## Add all Syntax Objects in DataGridView
Foreach ($row in $SyntaxHelpObj)
{

    [void]$dgSyntax.AddChild($row)
}

}



Process
{

# Creating a filter with custom log name


$chkBpxDC.add_Click({
    if($txtBoxHosts.IsEnabled)
    {
        $txtBoxHosts.IsEnabled = $false
    }
    else
    {
        $txtBoxHosts.IsEnabled = $true
    }

})

$btnClearDisplayfilter.add_Click({
    $arrDataGrid =  ((Get-Variable) | ?{try{$_.Value.GetType().Name -eq "DataGrid"} catch{}}).Name
    $arrDataGrid = $arrDataGrid | Where-Object{$_ -ne "dgSyntax" -and $_ -ne "dgJSONInput"}
    foreach($DataGrid in $arrDataGrid)
    {
        if($((Get-variable $DataGrid).Value.Items))
        {
            foreach($Item in $((Get-variable $DataGrid).Value.Items))
            {
                $Item.Hidden = $false
            }
            $((Get-variable $DataGrid).Value.Items.Refresh())
        }
    }
})

$btnApplyDisplayfilter.add_Click({
    $arrDataGrid =  ((Get-Variable) | ?{try{$_.Value.GetType().Name -eq "DataGrid"} catch{}}).Name
    $arrDataGrid = $arrDataGrid | Where-Object{$_ -ne "dgSyntax" -and $_ -ne "dgJSONInput"}
    foreach($DataGrid in $arrDataGrid)
    {
        if($((Get-variable $DataGrid).Value.Items))
        {
            foreach($Item in $((Get-variable $DataGrid).Value.Items))
            {
                if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                {   
                    $Item.hidden = $true
                    Switch ($lbOperator.SelectedItem)
                    {
                        "LIKE"
                        {
                            $script_block = {$Item.$($txtProp.Text) -like $txtString.Text}
                        }
                        "EQ"
                        {
                            $script_block = {$Item.$($txtProp.Text) -eq $txtString.Text}
                        }
                        "NE"
                        {
                            $script_block = {$Item.$($txtProp.Text) -ne $txtString.Text}
                        }
                        "NOTLIKE"
                        {
                            $script_block = {$Item.$($txtProp.Text) -notlike $txtString.Text}    
                        }
                        default
                        {
                            $script_block = {$Item.$($txtProp.Text) -like $txtString.Text}                   
                        }
                    }

                    if($script_block.Invoke())
                    {
                        $Item.hidden = $false
                        $DisplayFilterResult = $true
                        $FilterCount++
                    }
                }

            }
            $((Get-variable $DataGrid).Value.Items.Refresh())
        }
    }
})

$chkBoxDisplayfilter.add_Click({

    if($txtProp.IsEnabled)
    {
        $txtProp.IsEnabled = $false
        $txtString.IsEnabled = $false
        $lbOperator.IsEnabled = $false
        $btnApplyDisplayfilter.IsEnabled = $false
        $btnClearDisplayfilter.IsEnabled = $false

    }
    else
    {
        $txtProp.IsEnabled = $true
        $txtString.IsEnabled = $true
        $lbOperator.IsEnabled = $true
        $btnApplyDisplayfilter.IsEnabled = $true
        $btnClearDisplayfilter.IsEnabled = $true
        
    }


})

$btnExportStandard.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
#CSV Output file 
$StandardCSVFile = $CurrentFSPath + "\StandardEvents_" +$date+ ".csv"
If ((Test-Path $StandardCSVFile) -eq $true)
{
	Remove-Item $StandardCSVFile
}

#Export results to CSV file
$dgEventIDs.Items | Export-Csv $StandardCSVFile -NoTypeInformation -Encoding UTF8 -Force

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $StandardCSVFile" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportStandardExcel.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$strStandardFileEXCEL = $CurrentFSPath + "\StandardEvents.xlsx"
If ((Test-Path $strStandardFileEXCEL) -eq $true)
{
	Remove-Item $strStandardFileEXCEL
}

$global:observableCollection.Insert(0,(LogMessage -strMessage "Checking for ImportExcel PowerShell Module..."  -strType "Info" -DateStamp ))
if(!$(get-module -ListAvailable | Where-Object name -eq "ImportExcel"))
{
    $global:observableCollection.Insert(0,(LogMessage -strMessage "You need to install the PowerShell module ImportExcel found in the PSGallery"  -strType "Error" -DateStamp ))
}
else
{
    Import-Module ImportExcel

    #Export results to CSV file
    $dgEventIDs.Items | Export-Excel -path $strStandardFileEXCEL -WorkSheetname "StandardEvent" -BoldTopRow -TableStyle Medium2 -TableName "standardtbl" -NoLegend -AutoSize -FreezeTopRow 

    $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $strStandardFileEXCEL" -strType "Info" -DateStamp ))},"Render")                        
}



})

$btnExportFW.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$FWCSVFile = $CurrentFSPath + "\WinFWEvents_" +$date+ ".csv"
If ((Test-Path $FWCSVFile) -eq $true)
{
	Remove-Item $FWCSVFile
}

#Export results to CSV file
$dgFWEventIDs.Items | Export-Csv $FWCSVFile -NoTypeInformation -Encoding UTF8 -Force

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $FWCSVFile" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportFWExcel.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$strFWFileEXCEL = $CurrentFSPath + "\WinFWEvents_" +$date+ ".xlsx"
If ((Test-Path $strFWFileEXCEL) -eq $true)
{
	Remove-Item $strFWFileEXCEL
}

#Export results to CSV file
$dgFWEventIDs.Items | Export-Excel -path $strFWFileEXCEL -WorkSheetname "WinFWEvent" -BoldTopRow -TableStyle Medium2 -TableName "fwtbl" -NoLegend -AutoSize -FreezeTopRow 

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $strFWFileEXCEL" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportLogon.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$LogonCSVFile = $CurrentFSPath + "\LogonEvents_" +$date+ ".csv"
If ((Test-Path $LogonCSVFile) -eq $true)
{
	Remove-Item $LogonCSVFile
}

#Export results to CSV file
$dgLogonIDs.Items | Export-Csv $LogonCSVFile  -NoTypeInformation -Encoding UTF8 -Force

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $LogonCSVFile" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportLogonExcel.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$strLogonFileEXCEL = $CurrentFSPath + "\LogonEvents_" +$date+ ".xlsx"
If ((Test-Path $strLogonFileEXCEL) -eq $true)
{
	Remove-Item $strLogonFileEXCEL
}

#Export results to CSV file
$dgLogonIDs.Items | Export-Excel -path $strLogonFileEXCEL -WorkSheetname "LogonEvent" -BoldTopRow -TableStyle Medium2 -TableName "logontbl" -NoLegend -AutoSize -FreezeTopRow 

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $strLogonFileEXCEL" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportSysmon.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$SystmonCSVFile = $CurrentFSPath + "\SysMonEvents_" +$date+ ".csv"
If ((Test-Path $SystmonCSVFile) -eq $true)
{
	Remove-Item $SystmonCSVFile
}

#Export results to CSV file
$dgSysmonIDs.Items | Export-Csv $SystmonCSVFile  -NoTypeInformation -Encoding UTF8 -Force

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $SystmonCSVFile" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportSysmonExcel.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$strSysmonFileEXCEL = $CurrentFSPath + "\SysMonEvents_" +$date+ ".xlsx"
If ((Test-Path $strSysmonFileEXCEL) -eq $true)
{
	Remove-Item $strSysmonFileEXCEL
}

#Export results to CSV file
$dgSysmonIDs.Items | Export-Excel -path $strSysmonFileEXCEL -WorkSheetname "SysmonEvent" -BoldTopRow -TableStyle Medium2 -TableName "sysmontbl" -NoLegend -AutoSize -FreezeTopRow 

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $strSysmonFileEXCEL" -strType "Info" -DateStamp ))},"Render")                        

})


$btnExportGPO.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$GPOCSVFile = $CurrentFSPath + "\GPOEvents_" +$date+ ".csv"
If ((Test-Path $GPOCSVFile) -eq $true)
{
	Remove-Item $GPOCSVFile
}

#Export results to CSV file
$dgGPOIDs.Items | Export-Csv $GPOCSVFile  -NoTypeInformation -Encoding UTF8 -Force

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $GPOCSVFile" -strType "Info" -DateStamp ))},"Render")                        

})

$btnExportGPOExcel.add_Click({
$date= get-date -uformat %Y%m%d_%H%M%S
$strGPOFileEXCEL = $CurrentFSPath + "\GPOEvents_" +$date+ ".xlsx"
If ((Test-Path $strGPOFileEXCEL) -eq $true)
{
	Remove-Item $strGPOFileEXCEL
}

#Export results to CSV file
$dgGPOIDs.Items | Export-Excel -path $strGPOFileEXCEL -WorkSheetname "GPOEvent" -BoldTopRow -TableStyle Medium2 -TableName "gpotbl" -NoLegend -AutoSize -FreezeTopRow 

$Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Results saved to $strGPOFileEXCEL" -strType "Info" -DateStamp ))},"Render")                        

})

$btnRun.add_Click({

#Clear Item from grid
While ($dgEventIDs.Items.count -gt 0)
{
    $dgEventIDs.Items.Remove($dgEventIDs.Items[0])
}
#Clear Item from grid
While ($dgFWEventIDs.Items.count -gt 0)
{
    $dgFWEventIDs.Items.Remove($dgFWEventIDs.Items[0])
}
#Clear Item from grid
While ($dgLogonIDs.Items.count -gt 0)
{
    $dgLogonIDs.Items.Remove($dgLogonIDs.Items[0])
}
#Clear Item from grid
While ($dgSysmonIDs.Items.count -gt 0)
{
    $dgSysmonIDs.Items.Remove($dgSysmonIDs.Items[0])
}
#Clear Item from grid
While ($dgGPOIDs.Items.count -gt 0)
{
    $dgGPOIDs.Items.Remove($dgGPOIDs.Items[0])
}

if($txtBoxXML.Text -ne "")
{
    $XpathFilter = $txtBoxXML.Text
    $xmlFilterBlock = {
    $XpathFilter
    }
    $script:bolXMLFilterOK = $true
    try
    {
        $script:xml = [xml]$XpathFilter
        $node = $script:xml.QueryList.FirstChild.Attributes
        $QueryList = $script:xml.QueryList
        $Path = $node.GetNamedItem("Path")
        $LogName = $Path.'#text'.ToString()
    }
    catch
    {
    $script:bolXMLFilterOK = $false
    }
    if($script:bolXMLFilterOK)
    {
        $LogNames = new-object System.Collections.ArrayList
        $jobIds = @()
        [int]$Timeout = 300

        Foreach($Query in $QueryList.Query)
        {
            [VOID]$LogNames.add($Query.Path.ToString())
        }
        $strMaxEvent = $txtMaxEvent.Text
        if (($strMaxEvent -match "^[0-9]*$") -and ($strMaxEvent -ne 0))
        {
             If($chkBpxDC.IsChecked)
            {
                $arrComputers = Get-ADDomainController  -filter *  | Select-Object -Property Name
                $arrComputers = $arrComputers.Name
            }
            else
            {
                $arrComputers = $txtBoxHosts.Text
                $arrComputers = @($arrComputers.toString().Split(","))
            }
    
            if($arrComputers.count -gt 0)
            {
                $arrEventLogs = New-Object System.Collections.ArrayList

                Foreach ($Computer in $arrComputers)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                {
            if($Computer.Length -gt 0)
            {

                $Script = {
                param($Computer,$LogName,$XpathFilter,$strMaxEvent)
                    $returnedEvents = new-object System.Collections.ArrayList
                    $colEvent = get-winevent -ComputerName $Computer -LogName $LogName -FilterXPath $XpathFilter -MaxEvents $strMaxEvent 
                    foreach($objEvent in $colEvent)
                    {
                        $RemoteEventObj = New-Object psobject
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'MachineName' -Value $objEvent.MachineName
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'Level' -Value $objEvent.Level
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'LevelDisplayName' -Value $objEvent.LevelDisplayName
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'TimeCreated' -Value $objEvent.TimeCreated
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'Id' -Value $objEvent.Id
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'ProviderName' -Value $objEvent.ProviderName
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'LogName' -Value $objEvent.LogName
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'Message' -Value $objEvent.Message
                        Add-Member -InputObject $RemoteEventObj -MemberType NoteProperty -Name 'xml' -Value $objEvent.toXML()
                        [void]$returnedEvents.Add($RemoteEventObj)
                    }
                    return $returnedEvents
                }
                if(($Computer -eq ".") -or ($Computer -eq "LocalHost"))
                {
                    $Computer = "LocalHost"

                    $job = Start-Job -Name "$Computer" $Script -ArgumentList $Computer,$LogName,$XpathFilter,$strMaxEvent 
                    $jobIds += $job.Id
                }
                else
                {

                    if($(PingHost $Computer))
                    {
                        if($(PortPing $Computer 5985 3000))
                        {
                            $script:PSSessionFailed = $false
                            try
                            {
                                $script:PSSession = New-PSSession -ComputerName $Computer -ErrorAction Stop
                            }
                            catch
                            {
                                $script:PSSessionFailed = $true
                            }
                            #Verify that session could be established
                            if($script:PSSessionFailed)
                            {
                                $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "$Computer, WS-Management service do not respond" -strType "Error" -DateStamp ))},"Render")                        
                            }
                            else
                            {
                                $job = Invoke-Command -Session $script:PSSession -ScriptBlock $Script -ArgumentList $Computer,$LogName,$XpathFilter,$strMaxEvent -AsJob -JobName "$Computer" 
                                $jobIds += $job.Id
                            }
                            #Clean up pssession
                            $script:PSSession = $null
                        }
                        else
                        {
                            $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "$Computer has port 5985 closed!" -strType "Error" -DateStamp ))},"Render")                        
                        }
                    }
                    else
                    {
                        $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "$Computer not available!" -strType "Error" -DateStamp ))},"Render")
                    }
                }

            }
        } #End Foreach Computer

                $sleepTime = 2
                $timeElapsed =  0
                $running = $true
                $dicCompltedJobs = @{}
                while ($running -and $timeElapsed -le $Timeout)
                {
                    $running = $false

                    $jobs = get-job | where{$jobIds.Contains($_.Id)}
                    #Reporting job state
                    $colrunningjobs = get-job | where{$jobIds.Contains($_.Id)} | where State -eq 'Running' | Select-Object -Property Name
                    Foreach($runningjob in $colrunningjobs)
                    {
                        $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Waiting on $($runningjob.name)" -strType "Warning" -DateStamp ))},"Render")
                    }
                    $colcompletedjobs = get-job | where{$jobIds.Contains($_.Id)} | where State -eq 'Completed' | Select-Object -Property Name
                    Foreach($completedjob in $colcompletedjobs)
                    {
                        If (!($dicCompltedJobs.ContainsKey($completedjob.name)))
                        {
                            $dicCompltedJobs.Add($completedjob.name,'Completed')

                            $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "$($completedjob.name) completed" -strType "Info" -DateStamp ))},"Render")
                        }
                    }
            

                    Foreach($job in $jobs)
                    {
                        if($job.State -eq 'Running')
                        {
                            $running = $true
                        }
                    }

                    Start-Sleep $sleepTime
                    $timeElapsed += $sleepTime
                } #End while running

                $jobs = get-job | where{$jobIds.Contains($_.Id)}
                Foreach($job in $jobs)
                {
                    if($job.State -eq 'Failed')
                    {
                        $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage  "$($runningjob.name) failed!" -strType "Error" -DateStamp ))},"Render")
                    }
                    else
                    {
                            try
                            {
                                Receive-Job $job -ErrorAction stop | %{[void]$arrEventLogs.add($_)} 
                            }
                            catch
                            {
                                if($_.Exception.Message.tostring() -match "Attempted to perform an unauthorized operation.")
                                {                  
                                    $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage  "$($job.Name): Attempted to perform an unauthorized operation!" -strType "Error" -DateStamp ))},"Render")
                                }  
                                else
                                {
                                    $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage  "$($job.Name): Failed! Could not retrieve any event!" -strType "Error" -DateStamp ))},"Render")
                                }            
                            }

                    }
                }
                if($arrEventLogs.Count -gt 0)
                {
                    $arrEventLogs = $arrEventLogs | Select-Object -Property MachineName,Level,LevelDisplayName,TimeCreated,Id,ProviderName,Message,xml
                    $arrEventLogs = Sort-Object -InputObject $arrEventLogs -Descending -Property TimeCreated 
                    $bolFWEvents = $false
                    $bolLogonEvents = $false
                    $DisplayFilterCheck = $true
                    $DisplayFilterResult = $false
                    $FilterCount = 0
                    #if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                    #{
                    #    [XML]$TextEventRecordXML = $arrEventLogs[0].xml
                    #    if(!($TextEventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text"))
                    #    {
                    #        $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage  "Display Filter - Poperty:$($txtProp.text) does not exist!" -strType "Error" -DateStamp ))},"Render")
                    #        $DisplayFilterCheck = $false
                    #    }
                    #}
                    if($DisplayFilterCheck)
                    {
                        Foreach ($EventRecord in $arrEventLogs)
                        {
                            if($EventRecord.ProviderName -eq "Microsoft-Windows-Sysmon")
                            {
                                $bolSysmonEvents = $TRUE
                                #.EventRecord
                                [XML]$EventRecordXML = $EventRecord.xml
                                $EventObj = New-Object psobject
                                $EventObj | Add-Member noteproperty MachineName ($EventRecord.MachineName)
                                $EventObj | Add-Member noteproperty Id ($EventRecord.Id)
                                $EventObj | Add-Member noteproperty TimeCreated ($EventRecord.TimeCreated)
                                $EventObj | Add-Member noteproperty RuleName $EventRecordXML.SelectSingleNode("//*[@Name='RuleName']")."#text"
                                $EventObj | Add-Member noteproperty UtcTime $EventRecordXML.SelectSingleNode("//*[@Name='UtcTime']")."#text"
                                $EventObj | Add-Member noteproperty ProcessGuid $EventRecordXML.SelectSingleNode("//*[@Name='ProcessGuid']")."#text"
                                $EventObj | Add-Member noteproperty ProcessId $EventRecordXML.SelectSingleNode("//*[@Name='ProcessId']")."#text"
                                $EventObj | Add-Member noteproperty Image $EventRecordXML.SelectSingleNode("//*[@Name='Image']")."#text"
                                $EventObj | Add-Member noteproperty FileVersion $EventRecordXML.SelectSingleNode("//*[@Name='FileVersion']")."#text"
                                $EventObj | Add-Member noteproperty Description $EventRecordXML.SelectSingleNode("//*[@Name='Description']")."#text"
                                $EventObj | Add-Member noteproperty Product $EventRecordXML.SelectSingleNode("//*[@Name='Product']")."#text"
                                $EventObj | Add-Member noteproperty Company $EventRecordXML.SelectSingleNode("//*[@Name='Company']")."#text"
                                $EventObj | Add-Member noteproperty CommandLine $EventRecordXML.SelectSingleNode("//*[@Name='CommandLine']")."#text"
                                $EventObj | Add-Member noteproperty CurrentDirectory $EventRecordXML.SelectSingleNode("//*[@Name='CurrentDirectory']")."#text"
                                $EventObj | Add-Member noteproperty User $EventRecordXML.SelectSingleNode("//*[@Name='User']")."#text"
                                $EventObj | Add-Member noteproperty LogonGuid $EventRecordXML.SelectSingleNode("//*[@Name='LogonGuid']")."#text"
                                $EventObj | Add-Member noteproperty LogonId $EventRecordXML.SelectSingleNode("//*[@Name='LogonId']")."#text"
                                $EventObj | Add-Member noteproperty TerminalSessionId $EventRecordXML.SelectSingleNode("//*[@Name='TerminalSessionId']")."#text"
                                $EventObj | Add-Member noteproperty IntegrityLevel $EventRecordXML.SelectSingleNode("//*[@Name='IntegrityLevel']")."#text"
                                $EventObj | Add-Member noteproperty Hashes $EventRecordXML.SelectSingleNode("//*[@Name='Hashes']")."#text"
                                $EventObj | Add-Member noteproperty ParentProcessGuid $EventRecordXML.SelectSingleNode("//*[@Name='ParentProcessGuid']")."#text"
                                $EventObj | Add-Member noteproperty ParentProcessId $EventRecordXML.SelectSingleNode("//*[@Name='ParentProcessId']")."#text"
                                $EventObj | Add-Member noteproperty ParentImage $EventRecordXML.SelectSingleNode("//*[@Name='ParentImage']")."#text"
                                $EventObj | Add-Member noteproperty ParentCommandLine $EventRecordXML.SelectSingleNode("//*[@Name='ParentCommandLine']")."#text"
                                $EventObj | Add-Member noteproperty Protocol $EventRecordXML.SelectSingleNode("//*[@Name='Protocol']")."#text"
                                $EventObj | Add-Member noteproperty Initiated $EventRecordXML.SelectSingleNode("//*[@Name='Initiated']")."#text"
                                $EventObj | Add-Member noteproperty SourceIsIpv6 $EventRecordXML.SelectSingleNode("//*[@Name='SourceIsIpv6']")."#text"
                                $EventObj | Add-Member noteproperty SourceIp $EventRecordXML.SelectSingleNode("//*[@Name='SourceIp']")."#text"
                                $EventObj | Add-Member noteproperty SourceHostname $EventRecordXML.SelectSingleNode("//*[@Name='SourceHostname']")."#text"
                                $EventObj | Add-Member noteproperty SourcePort $EventRecordXML.SelectSingleNode("//*[@Name='SourcePort']")."#text"
                                $EventObj | Add-Member noteproperty SourcePortName $EventRecordXML.SelectSingleNode("//*[@Name='SourcePortName']")."#text"
                                $EventObj | Add-Member noteproperty DestinationIsIpv6 $EventRecordXML.SelectSingleNode("//*[@Name='DestinationIsIpv6']")."#text"
                                $EventObj | Add-Member noteproperty DestinationIp $EventRecordXML.SelectSingleNode("//*[@Name='DestinationIp']")."#text"
                                $EventObj | Add-Member noteproperty DestinationHostname $EventRecordXML.SelectSingleNode("//*[@Name='DestinationHostname']")."#text"
                                $EventObj | Add-Member noteproperty DestinationPort $EventRecordXML.SelectSingleNode("//*[@Name='DestinationPort']")."#text"
                                $EventObj | Add-Member noteproperty DestinationPortName $EventRecordXML.SelectSingleNode("//*[@Name='DestinationPortName']")."#text"
                                $EventObj | Add-Member noteproperty ImageLoaded $EventRecordXML.SelectSingleNode("//*[@Name='ImageLoaded']")."#text"
                                $EventObj | Add-Member noteproperty Signed $EventRecordXML.SelectSingleNode("//*[@Name='Signed']")."#text"
                                $EventObj | Add-Member noteproperty Signature $EventRecordXML.SelectSingleNode("//*[@Name='Signature']")."#text"
                                $EventObj | Add-Member noteproperty SignatureStatus $EventRecordXML.SelectSingleNode("//*[@Name='SignatureStatus']")."#text"
                                $EventObj | Add-Member noteproperty EventType $EventRecordXML.SelectSingleNode("//*[@Name='EventType']")."#text"
                                $EventObj | Add-Member noteproperty TargetObject $EventRecordXML.SelectSingleNode("//*[@Name='TargetObject']")."#text"
                                $EventObj | Add-Member noteproperty Details $EventRecordXML.SelectSingleNode("//*[@Name='Details']")."#text"
                                $EventObj | Add-Member noteproperty NewName $EventRecordXML.SelectSingleNode("//*[@Name='NewName']")."#text"
                                $EventObj | Add-Member noteproperty hidden $false
                                
                                if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                                {   
                                    $EventObj.hidden = $true
                                    Switch ($lbOperator.SelectedItem)
                                    {
                                        "LIKE"
                                        {
                                            $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}
                                        }
                                        "EQ"
                                        {
                                            $script_block = {$EventObj.$($txtProp.Text) -eq $txtString.Text}
                                        }
                                        "NE"
                                        {
                                            $script_block = {$EventObj.$($txtProp.Text) -ne $txtString.Text}
                                        }
                                        "NOTLIKE"
                                        {
                                            $script_block = {$EventObj.$($txtProp.Text) -notlike $txtString.Text}    
                                        }
                                        default
                                        {
                                            $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}                   
                                        }
                                    }

                                    if($script_block.Invoke())
                                    {
                                        $EventObj.hidden = $false
                                        $DisplayFilterResult = $true
                                        $FilterCount++
                                    }
                                }
                                
                                [void]$dgSysmonIDs.AddChild($EventObj)


                            }
                            else
                            {
                                If (($EventRecord.ID -eq '5152') -or ($EventRecord.ID -eq '5156') -or ($EventRecord.ID -eq '5157'))
                                {
                                         $bolFWEvents = $TRUE
                                        #.EventRecord
                                        [XML]$EventRecordXML = $EventRecord.xml
                                        $EventObj = New-Object psobject
                    
                                        $EventObj | Add-Member noteproperty MachineName ($EventRecord.MachineName)
                                        $EventObj | Add-Member noteproperty Id ($EventRecord.Id)
                                        $EventObj | Add-Member noteproperty TimeCreated ($EventRecord.TimeCreated)
                                        $EventObj | Add-Member noteproperty SourceAddress $EventRecordXML.SelectSingleNode("//*[@Name='SourceAddress']")."#text"
                                        $EventObj | Add-Member noteproperty Direction $EventRecordXML.SelectSingleNode("//*[@Name='Direction']")."#text"
                                        $EventObj | Add-Member noteproperty SourcePort $EventRecordXML.SelectSingleNode("//*[@Name='SourcePort']")."#text"
                                        $EventObj | Add-Member noteproperty DestAddress $EventRecordXML.SelectSingleNode("//*[@Name='DestAddress']")."#text"
                                        $EventObj | Add-Member noteproperty DestPort $EventRecordXML.SelectSingleNode("//*[@Name='DestPort']")."#text"
                                        $EventObj | Add-Member noteproperty Protocol $EventRecordXML.SelectSingleNode("//*[@Name='Protocol']")."#text"
                                        $EventObj | Add-Member noteproperty Application $EventRecordXML.SelectSingleNode("//*[@Name='Application']")."#text"
                                        $EventObj | Add-Member noteproperty hidden $false

                                        if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                                        {   
                                            $EventObj.hidden = $true
                                            Switch ($lbOperator.SelectedItem)
                                            {
                                                "LIKE"
                                                {
                                                    $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}
                                                }
                                                "EQ"
                                                {
                                                    $script_block = {$EventObj.$($txtProp.Text) -eq $txtString.Text}
                                                }
                                                "NE"
                                                {
                                                    $script_block = {$EventObj.$($txtProp.Text) -ne $txtString.Text}
                                                }
                                                "NOTLIKE"
                                                {
                                                    $script_block = {$EventObj.$($txtProp.Text) -notlike $txtString.Text}    
                                                }
                                                default
                                                {
                                                    $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}                   
                                                }
                                            }

                                            if($script_block.Invoke())
                                            {
                                                $EventObj.hidden = $false
                                                $DisplayFilterResult = $true
                                                $FilterCount++
                                            }
                                        }
                                                                                
                                        [void]$dgFWEventIDs.AddChild($EventObj)
                                        
                                 }
                                 else
                                 {
                                   If (($EventRecord.ID -eq '4624') -or ($EventRecord.ID -eq '4648') -or ($EventRecord.ID -eq '4634') -or ($EventRecord.ID -eq '4672') -or ($EventRecord.ID -eq '4647') -or ($EventRecord.ID -eq '4964') )
                                   {
                                           $bolLogonEvents = $TRUE
                                           #.EventRecord
                                           [XML]$EventRecordXML = $EventRecord.xml
                                           $EventObj = New-Object psobject
                   
                                           $EventObj | Add-Member noteproperty MachineName ($EventRecord.MachineName)
                                           $EventObj | Add-Member noteproperty Id ($EventRecord.Id)
                                           $EventObj | Add-Member noteproperty TimeCreated ($EventRecord.TimeCreated)
                                           $EventObj | Add-Member noteproperty LogonType $EventRecordXML.SelectSingleNode("//*[@Name='LogonType']")."#text"
                                           $EventObj | Add-Member noteproperty TargetUserSid $EventRecordXML.SelectSingleNode("//*[@Name='TargetUserSid']")."#text"
                                           $EventObj | Add-Member noteproperty TargetUserName $EventRecordXML.SelectSingleNode("//*[@Name='TargetUserName']")."#text"
                                           $EventObj | Add-Member noteproperty TargetDomainName $EventRecordXML.SelectSingleNode("//*[@Name='TargetDomainName']")."#text"
                                           $EventObj | Add-Member noteproperty SubjectUserSid $EventRecordXML.SelectSingleNode("//*[@Name='SubjectUserSid']")."#text"
                                           $EventObj | Add-Member noteproperty SubjectUserName $EventRecordXML.SelectSingleNode("//*[@Name='SubjectUserName']")."#text"
                                           $EventObj | Add-Member noteproperty SubjectDomainName $EventRecordXML.SelectSingleNode("//*[@Name='SubjectDomainName']")."#text"
                                           $EventObj | Add-Member noteproperty ProcessId $EventRecordXML.SelectSingleNode("//*[@Name='ProcessId']")."#text"
                                           $EventObj | Add-Member noteproperty ProcessName $EventRecordXML.SelectSingleNode("//*[@Name='ProcessName']")."#text"
                                           $EventObj | Add-Member noteproperty IpAddress $EventRecordXML.SelectSingleNode("//*[@Name='IpAddress']")."#text"
                                           $EventObj | Add-Member noteproperty IpPort $EventRecordXML.SelectSingleNode("//*[@Name='IpPort']")."#text"
                                           $SidList = $EventRecordXML.SelectSingleNode("//*[@Name='SidList']")."#text"
                                           if($SidList)
                                           {
                                                if($SidList -match "S-1-")
                                                {
                                                    $i = 0
                                                    foreach($SID in $SidList.Trim().split("%"))
                                                    {
                                                        if($i -eq 1)
                                                        {
                                                    
                                                            $SidList = (new-object System.Security.Principal.SecurityIdentifier ($SID.Trim() -replace '{','' -replace '}','' -replace "`n",'')  ).Translate([System.Security.Principal.NTAccount]).Value
                                                        }
                                                        if($i -gt 1)
                                                        {
                                                    
                                                            $SidList += "`n" + (new-object System.Security.Principal.SecurityIdentifier ($SID.Trim() -replace '{','' -replace '}','' -replace "`n",'')  ).Translate([System.Security.Principal.NTAccount]).Value
                                                        }
                                                        $i++
                                                    }
                                                }
                                           }
                                           $EventObj | Add-Member noteproperty SidList $SidList
                                           $EventObj | Add-Member noteproperty hidden $false

                                            if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                                            {   
                                                $EventObj.hidden = $true
                                                Switch ($lbOperator.SelectedItem)
                                                {
                                                    "LIKE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}
                                                    }
                                                    "EQ"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -eq $txtString.Text}
                                                    }
                                                    "NE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -ne $txtString.Text}
                                                    }
                                                    "NOTLIKE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -notlike $txtString.Text}    
                                                    }
                                                    default
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}                   
                                                    }
                                                }

                                                if($script_block.Invoke())
                                                {
                                                    $EventObj.hidden = $false
                                                    $DisplayFilterResult = $true
                                                    $FilterCount++
                                                }
                                            }
                                            
                                            [void]$dgLogonIDs.AddChild($EventObj)
                                            
                                    }
                                    else
                                    {
                                    [XML]$EventRecordXML = $EventRecord.xml
                                     If (($EventRecord.ID -eq '5136') -or ($EventRecord.ID -eq '5137') -or ($EventRecord.ID -eq '5138') -or ($EventRecord.ID -eq '5141') -and( $EventRecordXML.SelectSingleNode("//*[@Name='ObjectClass']")."#text" = "groupPolicyContainer"))
                                    {
                                           $bolGPOEvents = $TRUE
                                           #.EventRecord
                                           
                                           $EventObj = New-Object psobject
                                           $EventObj | Add-Member noteproperty MachineName ($EventRecord.MachineName)
                                           $EventObj | Add-Member noteproperty Id ($EventRecord.Id)
                                           $EventObj | Add-Member noteproperty TimeCreated ($EventRecord.TimeCreated)
                                           $EventObj | Add-Member noteproperty User $EventRecordXML.SelectSingleNode("//*[@Name='SubjectUserName']")."#text"
                                           $GPO = $EventRecordXML.SelectSingleNode("//*[@Name='ObjectDN']")."#text"
                                           $strGUID = $($GPO.split("{")[1].split("}")[0])
                                           try{
                                               $strGPOName = $strGPOName = (Get-GPO -Guid $strGUID -ErrorAction stop).DisplayName
                                           }
                                           catch
                                           {
                                                   $strGPOName = "<GPO not found>"
                                           }
                                           $EventObj | Add-Member noteproperty 'GPO Name' $strGPOName
                                           $EventObj | Add-Member noteproperty GUID $strGUID
                                           $EventObj | Add-Member noteproperty ObjectClass $EventRecordXML.SelectSingleNode("//*[@Name='ObjectClass']")."#text"
                                           $EventObj | Add-Member noteproperty AttributeLDAPDisplayName $EventRecordXML.SelectSingleNode("//*[@Name='AttributeLDAPDisplayName']")."#text"
                                           $EventObj | Add-Member noteproperty hidden $false

                                            if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                                            {   
                                                $EventObj.hidden = $true
                                                Switch ($lbOperator.SelectedItem)
                                                {
                                                    "LIKE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}
                                                    }
                                                    "EQ"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -eq $txtString.Text}
                                                    }
                                                    "NE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -ne $txtString.Text}
                                                    }
                                                    "NOTLIKE"
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -notlike $txtString.Text}    
                                                    }
                                                    default
                                                    {
                                                        $script_block = {$EventObj.$($txtProp.Text) -like $txtString.Text}                   
                                                    }
                                                }

                                                if($script_block.Invoke())
                                                {
                                                    $EventObj.hidden = $false
                                                    $DisplayFilterResult = $true
                                                    $FilterCount++
                                                }
                                            }
                                            
                                            [void]$dgGPOIDs.AddChild($EventObj)
                                            
                                    }
                                    else
                                    {
                                        #.EventRecord
                                        [XML]$EventRecordXML = $EventRecord.xml
                                        $EventObj = New-Object psobject
                   
                                        $EventObj | Add-Member noteproperty MachineName ($EventRecord.MachineName)
                                        $EventObj | Add-Member noteproperty Id ($EventRecord.Id)
                                        $EventObj | Add-Member noteproperty TimeCreated ($EventRecord.TimeCreated)
                                        $EventObj | Add-Member noteproperty ProviderName ($EventRecord.ProviderName)
                                        $EventObj | Add-Member noteproperty Message ($EventRecord.Message)
                                        $EventObj | Add-Member noteproperty hidden $false

                                        if($txtProp.text -and $chkBoxDisplayFilter.IsChecked)
                                        {   
                                            $EventObj.hidden = $true
                                            Switch ($lbOperator.SelectedItem)
                                            {
                                                "LIKE"
                                                {
                                                    $script_block = {$EventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text" -like $txtString.Text}
                                                }
                                                "EQ"
                                                {
                                                    $script_block = {$EventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text" -eq $txtString.Text}
                                                }
                                                "NE"
                                                {
                                                    $script_block = {$EventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text" -ne $txtString.Text}
                                                }
                                                "NOTLIKE"
                                                {
                                                    $script_block = {$EventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text" -notlike $txtString.Text}    
                                                }
                                                default
                                                {
                                                    $script_block = {$EventRecordXML.SelectSingleNode("//*[@Name='$($txtProp.text)']")."#text" -like $txtString.Text}                   
                                                }
                                            }

                                            if($script_block.Invoke())
                                            {
                                                $EventObj.hidden = $false
                                                $DisplayFilterResult = $true
                                                $FilterCount++
                                            }
                                        }
                                        
                                        [void]$dgEventIDs.AddChild($EventObj)
                                        }
                                    }
                                }
                            #####
                            }
                        }
                        if($txtProp.text -and $chkBoxDisplayFilter.IsChecked -and (!($DisplayFilterResult)))
                        {
                            $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Display Filter - No matching events." -strType "Error" -DateStamp ))},"Render")
                        }
                        elseif($txtProp.text -and $chkBoxDisplayFilter.IsChecked -and $DisplayFilterResult)
                        {
                            $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Display Filter - Return $FilterCount events." -strType "Info" -DateStamp ))},"Render")
                        }
                    }#End PropCheck

                }
                $Window.Dispatcher.Invoke([action]{$global:observableCollection.Insert(0,(LogMessage -strMessage "Done! Found $(@($arrEventLogs).Count) events." -strType "Info" -DateStamp ))},"Render")
            }
            else
            {
                $Msgox = [System.Windows.Forms.MessageBox]::Show("No hosts!","Error",0,"Error")
            } # End if arrComputers 

        }
        else
        {
            if($strMaxEvent -eq 0 )
            {
                $Msgox = [System.Windows.Forms.MessageBox]::Show("0 is to low!","Error",0,"Error")
            }
            else
            {
                $Msgox = [System.Windows.Forms.MessageBox]::Show("$strMaxEvent is not a number!","Error",0,"Error")
            }
        } #End if strMaxEvent 
    }
    else
    {
        $global:observableCollection.Insert(0,(LogMessage -strMessage "XPath filter contains error!" -strType "Error" -DateStamp))
    }
}
else
{
    $global:observableCollection.Insert(0,(LogMessage -strMessage "XPath filter is empty!" -strType "Error" -DateStamp))
} #End if txtBoxXML 

if($bolFWEvents)
{
    #Switch focus to FW tab
    $tabViews.SelectedIndex = 1
}
else
{
    if($bolLogonEvents)
    {
        #Switch focus to FW tab
        $tabViews.SelectedIndex = 2
    }
    else
    {
        if($bolSysmonEvents)
        {
            #Switch focus to FW tab
            $tabViews.SelectedIndex = 3
        }
        else
        {
            if($bolGPOEvents)
            {
                #Switch focus to FW tab
                $tabViews.SelectedIndex = 4
            }
            else
            {
                #Switch focus to standard tab
                $tabViews.SelectedIndex = 0
            }
        }
    }
}
})

$btnExit.add_Click( 
{
    $Window.close()
})

$btnReload.add_Click( 
{

#Clear Item from grid
While ($dgJSONInput.Items.count -gt 0)
{
    $dgJSONInput.Items.Remove($dgJSONInput.Items[0])
}

if(Test-Path $JSONFile)
{
    $JSON = (Get-Content $JSONFile | Select-String -Pattern "//" -NotMatch) -join "`n" | ConvertFrom-Json 
    ## Add all XPath Objects in DataGridView
    foreach($Query in $JSON.Queries)
    {
        $objXMLQuery = New-Object PSObject
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "Filter" -value $Query.Name
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "Category" -value $Query.Category
        $strQuery = "<!--- Name:" + $Query.Name + " -->" + $Query.Query
        Add-Member -inputObject $objXMLQuery -memberType NoteProperty -name "XPath" -value  $strQuery 
        [VOID]$dgJSONInput.AddChild($objXMLQuery)
    }
}
    
})
}
End
{
 
    if([System.Windows.SystemParameters]::PrimaryScreenWidth -gt $Window.Width)
    {
    $Window.Width =   [System.Windows.SystemParameters]::PrimaryScreenWidth
    $tabViews.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.01))
    $dgEventIDs.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    $dgFWEventIDs.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    $dgLogonIDs.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    $dgSysmonIDs.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    $dgGPOIDs.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    $txtBoxXML.Width = $([System.Windows.SystemParameters]::PrimaryScreenWidth - ([System.Windows.SystemParameters]::PrimaryScreenWidth * 0.02))
    }
    $Window.ShowDialog() | Out-Null


}

