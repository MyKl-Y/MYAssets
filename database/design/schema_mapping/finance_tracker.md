<style>
    attr {color: skyblue;}
    relation {font-weight: bold; color:cornflowerblue;}
    attr_cont {color:yellow;}
    .cont {padding-bottom:1rem;}
    u, fkey {color:mediumaquamarine;}
    fkey_cont {color:magenta;}
    fkey_name {color:dodgerblue;}
    comment {color:forestgreen;}
</style>
<comment># database/model/schema_mapping/finance_tracker.md</comment>
<div class='cont'>
    <relation>User</relation>
    =
    <attr_cont>(</attr_cont>
    <u>user_id</u>,
    <u>email</u>,
    <u>username</u>,
    <attr>password_hash</attr>
    <attr_cont>)</attr_cont>
</div>
<div class='cont'>
    <relation>Account</relation>
    =
    <attr_cont>(</attr_cont>
    <u>account_id</u>,
    <fkey>user_id</fkey> 
    <fkey_cont>[<fkey_name>FK1</fkey_name>]</fkey_cont>,
    <attr>account_name</attr>,
    <attr>account_bank</attr>,
    <attr>balance</attr>,
    <attr>type</attr>,
    <attr>apy</attr>
    <attr_cont>)</attr_cont>
    <div></div>
    <fkey_name>FK1</fkey_name>:
    <fkey>user_id</fkey>
    &rarr;
    <relation>User</relation>
    <attr_cont>(<fkey>user_id</fkey>)</attr_cont>
</div>
<div class='cont'>
    <relation>Transaction</relation>
    =
    <attr_cont>(</attr_cont>
    <u>transaction_id</u>,
    <fkey>account_id</fkey> 
    <fkey_cont>[<fkey_name>FK2</fkey_name>]</fkey_cont>,
    <attr>transaction_desc</attr>,
    <attr>timestamp</attr>,
    <attr>balance</attr>,
    <attr>amount</attr>,
    <attr>category</attr>,
    <attr>type</attr>
    <attr_cont>)</attr_cont>
    <div></div>
    <fkey_name>FK2</fkey_name>:
    <fkey>account_id</fkey>
    &rarr;
    <relation>Account</relation>
    <attr_cont>(<fkey>account_id</fkey>)</attr_cont>
</div>
<div class='cont'>
    <relation>Budget</relation>
    =
    <attr_cont>(</attr_cont>
    <u>budget_id</u>,
    <fkey>user_id</fkey> 
    <fkey_cont>[<fkey_name>FK3</fkey_name>]</fkey_cont>,
    <attr>budget_name</attr>,
    <attr>total_amount</attr>,
    <attr>start_date</attr>,
    <attr>end_date</attr>,
    <attr>categories</attr>
    <attr_cont>)</attr_cont>
    <div></div>
    <fkey_name>FK3</fkey_name>:
    <fkey>user_id</fkey>
    &rarr;
    <relation>User</relation>
    <attr_cont>(<fkey>user_id</fkey>)</attr_cont>
</div>