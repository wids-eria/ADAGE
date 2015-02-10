#Stat Storing API

##POST /save_stat 

Save Stat as a key/value for a particular user and application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the Stat</td>
    </tr>
    <tr>
        <td>value</td>
        <td>The Stat value to be stored, can be any data type</td>
    </tr>
</table>

##POST /save_stats

Save an array of Stats as a key/value for a particular user and application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
    <tr>
        <td>stats</td>
        <td>and array of json key vaue pairs of each stat. I.e. stats: [{"key"=>"value"},{"another_key" => "value"}]</td>
    </tr>
    <tr>
        <td>value</td>
        <td>The Stat value to be stored, can be any data type</td>
    </tr>
</table>



##GET /get_stat

Request the value for a previously saved stat for a player for this application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
    <tr>
        <td>key</td>
        <td>The Key to identify the Stat</td>
    </tr>
</table>

###Response
Will return the Json object with the value for the given Stat key

##GET /get_stats

Request all of the stats for a player for this application.

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
</table>

###Response
Will return the Json object with all of the stats key/values


##DELETE /clear_stats

Clear all of the stats for a user

###Request
<table>
    <tr> 
        <th>params</th>
        <th>description</th>
    </tr>
    <tr>
        <td>access_token</td>
        <td>The secret access token for the specific user and application</td>
    </tr>
</table>

###Response
Will return the status of the request

