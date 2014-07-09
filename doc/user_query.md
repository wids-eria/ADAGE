#ADAGE User Data Queries

These queries have been set up to be useful from a client to retrieve relevant user data. Requests must come from an authenticated client with a valid and authenticated account. 

##GET /users/:user_id/get_accessible_games.json

Query to get the Games a User has permissions to log to.


###Request
<table>
    <tr> 
        <th>params</th>
        <th>type</th>
        <th>description</th>
    </tr>
    <tr>
        <td>app_token</td>
        <td>string</td>
        <td>Token that identifies the client application</td>
    </tr>
</table>

###Response

A list of all the games a user has access to along with all the version implementations for the game. 