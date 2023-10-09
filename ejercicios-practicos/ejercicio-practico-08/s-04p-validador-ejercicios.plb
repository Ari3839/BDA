whenever sqlerror exit rollback
create or replace procedure spv_clean wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
134 fb
8jrXb8xEJL3kBt3Kkvmz75q2FHkwg/Dw156sZy+p2viOEl5r1pPE3Ara7A7a2Yr8MnzzjhTm
bH3NHm+icP67xi/oDifhLWgsaC4QEpl0sW9a2Z6i7z7tWhiEzFTubMgfg7YV7ECUazhJt9Ph
mulbG2mFbItud5M5XbskjaXk6/QxvOsOtMqnE+SrpEKrZMfaJL72mGvBOHGcJN9J376RHhoD
BSFUxlqeIbBUiPEPQFujkL+WTpQrPQ==

/
show errors
create or replace procedure spv_check_tables wrapped 
a000000
369
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
7
13dd 625
mAKj6rno8Qfe+Aa38DDceww6sLIwg5XqVcD83y+5Kq4tv0BKQPvm/5Wh+l8d8peOfCok6+v9
8Hxmzne0w98poUmWx9H4nu3XbVybKOfIOtdZgl/KoynrucRPPB68eSpS9pEL55yW21iCwSjT
s/TGFeBPXzm0uVhMdAvrSPl+gw3ToFsC4d115HsVM5yBzwhhCT5VlUAtMYg4ffBFKLS8DDzL
29NoZhDZ/Mi83hNVDUKxezBloZj+EUPRSwgOc9rfLHv9Txg9ihEyOOv8MzscubL6UKvskHHd
gP0LJZX9nJ4oziZVth4OL6o5c39/W6zja92KX0XtN+ZHBRPMHCvlFTun6Xs8tkIEACLgBWfA
JARuLh1lk9fJX7dQcxP3bEP1NW+2oAFC6NuBFzVllrGh+bL788ZspH0FefP0gQyz3Tjb6tyg
Bo5uqceLoo4UxaIV8AQ9mUFeke8ZKPK8Injd51hJn/RV1STF+VThsdDhzjRu6jjU1kQELR4g
IAU1/FBsV/myeICEdM1IH8SD6M6NpGx2YWWt23u0L5PY3wkd5VGK6hVUu3OaRIb7WYi4M4oY
cNZpMHVAxT8sSjIT1WK0UhYWsKqIlCZtY1dfXhTzXCcUbl43DKc1jwHAaejf8mlJgfJanx1N
1ZBwLXTPi4AUnmb8eWtHVwuRr2/7qgAPogVKSai7Sa22s1zzTC9yYNhadCqtaIVrSl1dYttT
9F/+lDSkoxtQ7QZG0mw+CK1kq2vWPVsp9v9MOJ2FjiocKsVNrPVBG8KrXpaPl2yz6MLYDI25
JRQRwQuvuZAxx+rHqhgj4rvVhakSTQRbx1I1jxh2JGafRMvAC3JuPAIk/P4tTEe2XCY4z68d
HWwL4tL/qIbpc9AWrhOZMYVq2QGE9LlNdp9I98OVc0Ebn2SDQ36Kd8qkbNfZ7puWxtw2xkL6
/AdByEcjRLaTlXMEXJERDgl8oIDtydxxTSvxFG7kS+2oQdruiZ3TBxjLp0dVFkdBvrnDer80
qdyEXZKWd8ewIcAdJKJL9ZUWOb57c4slyW7+3XccvP/uWyGHRR2PZK2GdGgmpj4rzLJVDiMp
2EB+DIeBMiQrD/4LQju02fi/NeCmR9BzPfjqQG8TfCy0eC1yQ2maJ93P7jDnXA5pJJh52qLa
3a9hLreZbM0st0o5d9GuhHv4XmPPbXStqxN+FLHcafFBy5vS/qpndij0tW09CvVYI4ihRx0z
jVLGMkZcwhwY4NvPxmOoS3wjtRy+y5QfqDL425i8xz/R4jNhSa8UsfiSRhq2sJFjPzIrudVD
rsJopyRM8Y29cyPmK/lxf1QCdwdjgKTfKDQ+hu4B9DXF4npgAkZqQq07/Dz6CaAkOKJE65MN
TFAgCNh9M0PqojqCbSVvs2tBjCppzFQmSS5/Wn6crlmVS1/9YsKeMf8am0hLREtdN2oVyNuV
M+TEymxh1g16loUDoAocnw3yCsTCPi+MLU7JkKE9tuHz8KG8HuYtLXGuPVVS25stH/xedUzB
c6qG3xCy2m3DPR5fYR70VQ6L020SO5gs+R3Y4i5o

/
show errors
Prompt Realizando limpieza..
exec spv_clean('&&p_nombre'||'08');
Prompt invocando script s-01-redo-log-buffer.sql
start s-01-redo-log-buffer.sql
Prompt invocando script s-02-shared-pool.sql
start s-02-shared-pool.sql
Prompt invocando script s-03-pga-stats.sql
start s-03-pga-stats.sql
set serveroutput on
set linesize window
exec spv_print_header
host sha256sum &&p_script_validador
exec spv_check_tables('&&p_nombre'||'08');
exec spv_print_ok('Validación concluida');
exit