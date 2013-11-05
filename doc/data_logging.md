#ADAGE Data Logging

##POST /data_collector

Place to log click stream data from games. This will accept lists of JSON data. Data should be derived from the base structures of the [current ADAGE data spec](drunken_dolphin_data_spec.md).


###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>app_token</td>
        <td>Token that identifies the client application</td>
    </tr>
    <tr>
        <td>save_game</td>
        <td>A JSON object containing what will be saved</td>
    </tr>
</table>

