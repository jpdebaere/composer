ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��TY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���W�^}��W�^U��r�b6-Ӂ!K��u�lj����0!��F�������6�r<e�Q��
Q&� 0wD�Zh9�l�����\�7)����v4�X��2E9�nk
t�(
 �O�k��2\Y3�}d�M�֏%�ZS���Fׂ��:�#��@�"��i���% !��¬0k��e��f�Fn)���e�t���62�5���� �
krKw��a@�E�*�fM�!��^�����/�)�aT�����1(�ĕ��<9��Y�Fܼ� �A��6fFӹ�Ϲ͎F���]�&X��ل���5%�PBA�\kB�墔Q��5mڨW��7Cq`�
H���c.궥�E"~�0<���È��8�3�Hҋ���#�(�ɽ����j:V&�q�v�͖��<��.9o���8W�a�c#YZ}}�x#LXp�Z��i:�Ni;P�8&l�r�:�KH.��$i�<�S�uU�Šh�PE�5Y�Q�
�;QmjD^r��NYJ�6��� V���-��ˀnǴO���� �\h��r��#�����=��!�Cx�G=4r�4�$��W��z�?+,��c,�< ��s2>��L��P�U�cxT�iܖi���g9�?������1.�������T5#R���-[��~�(*��j6
����X�<*�wJI�����h������+r��2��Qg�!�?`#�X�qsޫ��х����q���d�-��ǎi�	b��]i�aY^ �/��9l���؅��������d�E�F"��p��m@݂6(�0�&�5�q6&, �P���L���P7-l�A����e㵗πekm��<�v� ��6L{Ȩ�a���HD��C�q�h��^.��n*'JCF�Io�I�M�����%�[��4�jV��^e)rH�5�7&��fB�n5�poA�G��p�p����'L�%dMM{� ]mi��m���	Kt��[ ������H�/�B�[�I�Gë�\��P�\��p�o��P�1�C1�41\XB��X�\��u=Evn�N��8){�?
a뿹@P����Z� Fq�6d�h�Nk6�6D��-�Ќ�妀C�9�i=}F������J��:}Fi5�k�i�_��o_�,4B@�az��yˈ�(����@u؈��ul��(>I�TMCĹA�r�:w%�.d��4d�& �Pӽ���ѯ@3Xkd���:eѯ1��Y�iK�7�u7�y/�uLk�� �^h*���>P~`�zj�.8Fb3nf��$�M��~�,���^dz�TJ��}tn� f0��c{�V��J�gE�[�Ka�U}v��(�*���tA���u����Д0�v�4�}:�OI_Rِ�k��_�4&F?������l~o~�O/ޮ&���������z	@Ն��˗��C���^ռM@XCx�Ls�p��
��\L�#���q'�3����?_������c���-���g�fϐ����|�ӑR��O3�L�4��<}X�ê�m�4��ݴ-W=�e�84j �Ǵ�T*SZ��pBU63�r��)TֿGc��1���VW�W�O��/�1KDQ�#wCL�2ɣ]�T��s��..Uf_�@ �Z��HIwZML���A�g�s	&X�t(�;��<Q�x)��d0
1�W*���+b�rT�d��N�j�������Qc�γ�"�^gy�X'������0�շϟ�,��W���d,����'6o߂�r�(�W��rH���jV�M���^��8-��	���ZQ'C��C�oE�����Ѓ���x&�1㿂V.��|ϸ��3�_����q����l�w� �$�Q����1f!�󀻗��M��ǆ���D�A(dٰ����<�2�3���Q��0F�����Ә��3�х��<`r��n�&��~��?�,������s��I���?\��-�?s���_	��M��m�жM��l�p��fS6T'L�x�����ol Bٖ-��ꑼGw$�m
�8]ǅM���_��yF�OY�F�Ӎގ1�9K��n�"=Қ������b������季�l������B��&�5��H����Z��ʉ��R�d�oƦ�<��F�z���[�D�gF���?�P�>r��/�|OW�$V����l���z��p��W_x0�w(�lE8b!&̆�^*Lj�D�cz��|�3���|[x�����?'��?x������х)`�^�K���J�:3�	�����Y���?x����'��mY�f>����A����m�I����G�����7��+WĞ��ܿ�\f��j� ���Y���~���nV�/Qȡ9�?R�ĥw4�	�˃�Ь��������z�t���#��k���u�e���5����2O�m������Q����=Ys+�wb,��O�hF�<��HER����`�[�������~C��w�2�Wd(�#�׸k���3�nOKc����~��_��5�$���o������K<j��X�#���K��
q$s�N���	�T.�&��⑈�I91�-���1O ���\��1Đ+��!,)�!�!Q2B.�c8���tT��ґ�J��rYܩ�SREJV�A��,*I����*�-C;C�p�-��e�rvП`��|:�ɥ���]i{=%%v�#�3�uT##���̑�*��[�(n��ٰؕ�������N)S�h�+J��mTl�:*��Y�*��ξ�,��[V���u�8�7�@W�w@�B
Xvt-���� �T�w.�r��[M��g\���o��C���wS������0<�#1\�����G�F��Gvɝ-�
�p�}�KH�9N�n V_�S;{���N��_C}�)|�?p���o b��L�Y��������x:�go�4��9�������c0m���R�I��s���h������M�?!�=�E��0�.�5n ���d\Ƴ���S���ly�y��^���S w�(X{� !��_yw�u+��p�0���K'�����_X��2�p���㘃� =���*t�I��ih�gO�_�~zfKi��1	�k�i��6�BL��Q�/ǣa`!�s�~�?Y$�T5�z��>z�wy��:����a4����P��_<޿���3(������o.p[�/�?L�E�u͠����bZ]��Oފ �}m��e����Q�5f���9�oF���c�[-����D���#3c�y罔��)`h��������U�}�|I�"��0�`��;"c�H��O2�=�!���{!�2]�/1�ޭ�굚��<ī����k�	�Pt��z��u��1��Y����;�����n&���Y��|�����i�84��L���\��?	��z��(MEa���M�8�f|A�54�h�w�;�b���u�,S���á��;���x5�!���E(�h��
qV�P�V��\�BYX���
E�qLT�	��U���P���\��Ԕ*�rp������	��B�'�V��j5M!w��!	)�Ɂ�T�d62I�"��C#��$���IQM��N&!�3��nQ�l��
����Uk�L�\�J�맍��|�XL�ǉN��t�dq?�[,��Ϋݝs��E�DvGJ&�[EnÑ��J���+�^6Q$q��ln��he����˯s��s� �P�ԍl�}ed˼���>ӷ��v�r�#�y8�c�D��a�r�"�=Μe��n�r ���&�ò�*Ź�*Q��&�����V��lG�J��:Vj��:h�v�M��-�w6D�)u���^�~h��W�j3g)\��-�t6�ԩT� q�f��IՃr��܍�ﱝjz��ϭ�ٍ�����<4�̃��1����;%�T�.J�V�\�8I�N����u:�˛[{����F���N����d'����	��D��� 윿6��xgǊ����d����v�-�9-�;�:����I��}�{�l"��Y}U,f���N&��X��@-�Ȋ'u�D�SLfE����O(��D��ɘb�Ըvn�9=eaY�ǯ���y{���l�y�U�"m^>)�ͦ�IֽR��ꋩRG��L�*�n�[�Fk��fU{W+��VZ�`���Jj_�W�Ӫ�0�L��;�b�b"�WQWW���ճ㍶���xE>5R�v���Gڇ)�#����}�Sx?��#?�6���f�/����Ot��������
0��������o��{ޤ��S���w۹;�_t��/`>�?A�g��0��GYn���| �J�]4�-i��>�����X�D��$���r6��~#����H��4ӑ��\,�����=XIȱ���;~D�f}���]>Vef_��^�&���t%1��b>ƾr��g���A$�P3�%G4#u�yD���d���LّNՒ��N�?W�m۪�*�n�T6�~;�y1�Xl����hFvߵ����1��F�~1���m�oU��x�a��ܸ�a������v&��}��M�1���AffsLq}=8�svߵ�Á�忿�vϦ�1I��,?l���?��_}J���>{��>�������!�y����)�^��<�����8�aUUy..Q���8c�JMV�|Ma�����"�+����� ���������o�����_���������=�7�b�W��yH]]�/=�~"Z�����i,}����y��e˅���������i8��j��ҟ--Q_��#�e�����_}2���g��3@�����	q��X���>]�z��x��~�gk.���?Yz�"?���R���o��ax)D�������������?���>��o����o�ʟ������x?Ev[6|ޠ�g��\0A�6:���G��������2�LQ�)	>=�㝑�� �Xi�����P�	��x��h�#�U"c3�;嘄e��+��WNDYrK���t����g���0M���
	ca$�69�^X5�1���(��[��ex���'#})ټP�d���W9(�Q�k�PSXc�x��e�E�V9�Z��V9[�2'�G�	U=�5��!ջ�`�<��0R�k��cO,4>ʆv���]I���u�ēIgz<Q0�+�ә$�3�D�j���&J�(��(Q94�U���T�t�C	$#��G'd�$�þ �r�{��'��TU��j��RyZ���j�q����{����@Í�m��u��j�W������-y�*mSϟ���
q�8��B��J+�ǱV"�IÆe���'��lEYa+����ק�?r'��EY`�B�y�H��5_,oY@�qO�q��S~�X+tÏ��q߉�߉&˱,2�����s%w����p�Fyq��u݁��tG��p:��=��� wܙ�9ڜ�3�9Y���[�'�?�	�R�7E�x�ΰ�]�[�]�k�8w�"�[ny~��z�-%���6n����������o�$|�o_��y�X�T�\��/lޒ��^��e�I�%Ϻ��%9��,���X���ŝa�����]��[��O�j%_�j�Rؾf�g��z�`�Y�k�:�W�$���{=?J:ȅ�x�In�QõZ��L/�;�x�׮�b�d��8�����	�B�ָ��0��xbV���IK#\�?�1�L���W���rhWX�Q�x!�G�f��UǷss�2\|���
��͐
I�2��N���~�Z�����ǣ|\̅����,l�낓�f'�����[��#��x��V`��gz�ɲi�EP{�h�]C;���t�A���C�W�B���������>�mF̢��R��L˃W��Vn��D�N�nJ2��T~x#�?9	\�bz?�������[���q���`�|�/���߭����W?~�/_�ۯ����|����������~������4�t����������̓��|���j+|-ɷ](����8��a�a訉岸	����δ�l�M�	�2x����#K�VA ����a�ݺ�g_�ׯ~�����m�7~������~���}#�C�g%�OJ�w ����ԏ�O���[�h��~���������}�|��o����[��{���_�$7HR�e��I?N��ڀ�$�9�Bh�}<Hw5�$ys��[�������
SvNJ�[G�������:Z���4���1Ca���Kq���O4�7�b�)ds��+,�������t�&�d��h�GX� [��BǨ�U��LP���ՑF��,:�̣" Iq�I�3�d8�$���D�.KN!�"I�]��#�?r�|��J�tjܐ�KN���ܞ	!W�fl?lv�Oΐ����&J�CBҌ�j%��6/�4?lK��V��@f��2�7�sj葭d�r�e=R�)��(�Q��D#1k&I�H�`)�d��c��./�.E�n�M��Y0R�r ���u4��=�籲�{�T�ݶw.1ݩI�ʓ.K���Fk�X�T�S�Qm�W\p^��\-���x%�`�"m�S�q��ŏH�UiK�Zd�f����)P~@��(B<ݤ�X6�O_�bUQz��$~����`��XA윕�X
BN�݅L�'2,x��v���FV���y�"Hl�D�\t���:S�b�!E|�f�6�nAr�
���c6	��9����tNo^��aƲ�4*Rh]ͣ�8;�F������l^�"�Z��X�=գ�U\O"/
��M��2}^������8��,�j�8 )�9�M2V�� ��H��M�g>û�b8 ��1J�$�[���K��:͕�$��|8A[C�כn�U�����ۄb�dCYJ�9�N���Ȱ�~���Rn�~�W�E�<Kİ�h���>#a��9]?��|K+�1�}`>�"��J�:w`Վh���A�U�	=���`j2*K4k�N��e�������pf}�2a!Ş����	l�f� ����W��s�gx/��(C2xs�J�<O�GVQ4�~�M���d�r_��BXfs�Yǂ��R%��U������R��]E�b�35�!M:�	�{�^��oR�ܴ��i!p�:�e<�M�x��� 7��nZ�ܴ��ip���K��\ ��+�o?\mE��ne�z�^J��:H���3�;|-ټ^��'g�'�R�3~q�{kꉇpz��=����x�<��o������o�[��K}�^�O���x����*�JJ�R�#�i�|
/�h'�{�:���]3����L�Ф��)M
/�]�>�0��Z���kٱbyPШe��֤P�"Ŗ'n$��ö2�J��XӜ	��+%^i�X�!"C�6�w�S�z�Ӗ��`n7L�J-V�F<����O�����M��,�RH���,E�6������6v�~��M6�#�S/��Au��#���l�&�`ͼL��!˄�ku3�@@x.J7K8��3V������dՄ:�m�R�-1;Q�W��R�n0�Q;{*��F�i�:#��6m6���Xo�"t�jGB��fD6 �G0 S�G
7���������������<U�ԅU&��d�(<���4kh�z����S������X�R��f�5b��?�6���/*L�����3�!0qSE��,�V��U�M%�n*�,T��\b!V�U�T��N�d���T,�*y
�lQ�� ��̺���1�?��=ט��N�~�����?�DG�}:��b�"����O> �Ӽ���|p��K�����y���3ǿ}%�T��Nw������PzR�]D(ʙpCq��g���)+n9�%1b���e��	� O+�6]G�i`eU��G��m��Ǿd����&FC!�X�+�.R�@.PT�oI2:rfd�3 :�	�tI���uq�^c-1z�`�z�<�$�k�B�T�2��T�=�f�E.�G��*��t�֜�&� Db�cǳ�E����QT����M���GE��Bl:,=w	Rx(�cC�;sr�P�b�-:��h�[�9�	�*"^'�Q���ѧNG0�G�z�F漄1r`�X�e��̲^id3e܅(m�%j���#h�$��^9��X�;=�EXTXz<(T���D+���c~����3&]/�֕�#�ϒ{i�$��@����m5K= 	�<a���� ���K��'	��Q�`��v����j�u)VZHg2K7�=��bd�_ҥ�h4�b��Aˏ�]���j�#�c��ڜ�(!?Y܄V���Q LY����`�����T���Ɋy/p8و��t��0��̦C���5(_�i���)j�;宦v|��j� �ꪙ�t*aI�|��V+�a��6��iO2��]*4�}�ݻJ�}��>�~�����G�v��h�g,Z��=��^��kWBp!�����iMZaC42	d��&�����>��Gy���3�����="aA�RmQ�B���,�R%�Rk4n�u;(z��'�]�x�H�rM"Lf�l5�zJ�ƀ��-�5f� �t>�՚G9[5��p��;Đ�,���H*�#)鑱@��k�+�<Y�c�E�����j�V���uG�>��^�Q+X4��Mш׆Hٮ����4�ΎJc�~�Ƀ�Wo��WU�R����B�$^@�+��8F����UT[�f�
�H��H���q�C��i��ԗ^J�E�H���[?�8�y������9�h�2����d�㑻hz�����Z�p*���z3�
�r������W�������J��z� x�O����'��.���GY6�N�|�瀟E0�+}��{�\5�:����s��x��x8�=_�|��e�T����{��,q��z'C�>�f��;��!{�3u��T�=;�_\\�i�۫��hb,j���;�IL_8a'�7W�C���
C+L�Z�xw[5_R����2��?/*=E�����k����g08���}t���,��r�'�Bd?��A�|�7ʦ�f�Q���t'��a�f�?h���6����e�殿瞶�m��S�?��{�����@�y�ǲ��o�n�/������i��{��9���&�g���c�_t�KZ��=�������s�ǐ�����۠������/웺����m��%���L����?���t+��p7�<�}�z�]���Cw�����3{��6h�����;�;����b�w�3���]����ۿ#��?�������ϷB�~ �.F��������~"������e��w�c�/yu�>�C���/��w'�[����۠;����q��Lw���`�������۠����+������T�����fܐ�P4£Ϩ��?s��(�طo,�y��2��ǧն9(Wg�$<���<�B���r	�S�*�@�Q�(�fr\���.��2�e��;�0�p��Q@��RC���lk��$�Q�3�Q��x4WG|0nv'C%������ �s�eӍ!�����A"]�q~�WxF�1��O;H�!*�)��(՛X!�u��`���D.�����'M�Z}�ׂ���͆�AӹZBAZе�e�Qv�Z�=�	�ް��,���n�vl�u�Y8�G���������������#�+�of�& K�	�33p�,�!
麭�3J0j۹6��z6�ӱn�m�$��Kz?�t���M�����Ak�M*���s�g�c��+�^'u�N3�AQ;����7z����A�.��X�@��F�����YeN�9�;��@D�5��<�2X�N*8�p��̒���ޙ5)�eQ��_��F���C?� *�2����™�����{��ԕ�����z0��T*{���:�o_��"�tS��m��,���ڝ���g��;5n�y}��C����Z��7������??�a���^����4q������&�B��I�)��n�F�Vu��)�������?����a��a�����{��/��4����(�9A���c2��y>O�,�R!�������N�<�%>bY1�h>���������� ��~e�_X�1Î�{�"Ѥ�"���6�h��_��Џz�V�u�O��=��Q����®˵{eB���.nh�Ă<,�*�d.�.����<�z�l'�B�]���A�%j�B�Zh���_E���^px�S�s�����Fx{��T%, `K��g��,���X�?���hF�!�W@�A�Q�?M�����и�C�7V4��?���r��k����o����o������B�����+���w����ӯ����w#4��O��������O���������J����?���/��O���M�MY����!�j�a�Z�c���ks��G�V������Z!�͵V��',/jb�{�����1�lr5iw�hٳ��T�e�0�\&�c���cG�gI1ܵ/���9�c)��u��Qخ�Y�Ok��p��tEk�h�%(�Sx��J�Ko�7��1�|w��GKo�cE	�n׺�,��g���m+�H=�N$n�l�6��#+4�H���������jw��E�J�����ʎ�`6Ի�7�����4Q:Vi'�iu���9���H)�x4�;;�s,�.T^-]{_�W .����
���~����{���~9� ��`���������������N�P�A�o���~Q��{�����;���!�OƎ�]z�Jڶ��攗�&�d��<�Թ��������d���?4d�ny�pg�5'6��c�?�Z�^����IN�i�';��������r�?��zVV������۩�Y����Nr+Ql�'�����pc.d�C��z����J�(�`���@�k��~>���hqI�#ϡ�������x�@E3��+0���?��EG��+@x�����t����������������O#����T=�)��	�����3����8�?M���d@���)�w�SO��X@�?�?r���g�@�� ��C0 b@�A���?�b���F�G�aeM�����q������������?�"��������?P�����G����������������CP���`Ā�����j��?46�����18��������F���>�j����Yo�uf���Cۣ�@9P�o���_��sS!?��^0Z'EW���'���qu��ړ4��qb�O����4~�v��2$"c4(za��b=5�5=:T������aW-�2������-g�v0Ɋ�P�->��������W���Kko~i��B��N��2�Vfǐ�F�x�ycV�r�RҦm
�����:���_j�~���4KeUϡTG_���K�BZ�D�&��)�0�sq(�A���	���`pX\� ��c���iK��씳�c6K�Q$O�C�}e�aQ�Q/���k���*�V��!�������A��W�������(r��#Q����Aq)-�"�%yLQɊ�$�<%�l�Ͳ+I�(0������{���3w����<��&���O�ww:�2����{wש|m�Y��:z�,k��ǆW,�����M I�`�v�bF
]1j�w��dl,�<�Ȳ�u�U�U7����jC����[�=.Ǆ�X�7��p��o�!�ޔAZD��ު����arN�ta�mXӻ�5�N�?-�ӛB��c���@GS�����?���?�?t`�����������G�����|�FP�����A����?����@���?��@���]�a�����L��?"���o����?�����A�������?,��?������ � o����g����7����Q<�?�����{�;{����ϸ�����́ݍ��7��q~�f��1Ώk���[���M&͢1�:�΢�k׏���fv�ѹɃ��p*���i����m���TC�R�6�5ެ��]���zZMMC���v��7�2�Gg�������L��T���g�\��}��u�����j�{ħ�JG����s�ZsYSO#'�>N�z^ׁ�3�3[�t�gj�:D�c;�A1�n�,뤽
<�ނ���
�-��عu:9�'��ps�����Z��R��{��g��]��MX��1���e����b����i{S�k�U��]
�c���<�-��ȯ�{*s����X��{����ɡ�g.Z9��f�GS���UR�Z�m�?����3�Sh��6]B:tC_w)�Y�.�R��K���UnJ��5)��y�שAޤK�=WN�b�ߪ��Y��B���������?������Ā�������E�%��S^��,K�f���"^��H�>Ix�&�4�cI�Ɍ�sV�h&O�$�R:� ����A�!��2��!�-?�*{N]�-��n><����)҈����<�[��S��5f�A�[]iw�V����Q{�Ug�Kp��~��N��S;чʭ��χr:��(��lg�������w�k��v	���[����x����!i��� ���z��������K`yW���?��i��	p���BGS��������@
�?�?r���/d ���B�?�?r��������ۃ����BH� ps4��?:��0���?:�+��e�����ʂ/Jv9P���.�g���"L��?5���w�s�t���Pr�~���;��������Y�Z�^���m�u��T��;6]�]wH�ej����x�o9�k�(Omm��-=H+���ej_�Pr�n�z�\�@���>���J�y�q"�a�ߏ�5U��>8�%���\���;}M�o��h}�wn:�9�X�9�Լ��*v,ce��{0��|��C�*���������B�!���?�~D���_�14��&����o��3Lo0]d������N�K"���O���E��}��A���;��]8�0�h-�jR��f^�n&�q����e����b�;�emne4=�ֵ&��DH�����W��-�t���R���N�����&n���k�7��T��mxɻ��1R���ՓUE��
����c�Dx�j��x�q�n�^��j�:Ln/���Ӽ?�
y���2�}-�:�땚Z��l�[�6���v�i[��]X�������!���������B6�����18����� ��	�������������a��L�e�G�ԩ�P�M����n*�go�'��N
��5�O|��w�|/��U/gF=v�/�d�R�],_�|�5�b�`΃a�/�	��ܦ �nN��q��^�hd�zzY��\M�diZ׭S��2�l�/<~ww7�=��q��Kko~i��B��N���ү���1���1�vy�8i�#iFF���7�T���t[5�S��{�x���=���\65�ӷ:tw"u|�ksim�m��=C�!�h�3��M����EZ��D�e,s"�5��s��>?�֭*��ݢԒ�DWvN�oc��,�?��B�����}�8�?����D���c9�J�T��!�"���Ld������GOg�0��sA�!����A�_�1p�W#����b�:�2Q]�GqXv�*\����`qv���n�5 ?���ݝZ���H7�50�^Om�f{�6��!H�6�Nw�pu.�}�k<�I�%����k��l��&���)�#c��%	�_���域�0��o��I�_���?��H�_`������7B#����Ҕ����7E��k����o����o�������?�gS�#�L�s)RQ�$�9)�".e��Ĝc��cy�.��L�<�3h�8��W�
��W����yS8���$���3j=�c�3ٖ+�n������\�d����u��S��ۻ��,F�}ϯ��%.���u�G�t#cM=�\�<�*�y%,�YWS���<[]�U-��j�w�����������	�_������JX ��&�����Y8�����_Qь�C�7��������~����q���o�hJ�4�����!��!����/��P�5B3��|�
���]���p�:��������5��r��� �a��a���?�����b�q�����p�8�M�?t �������������G��翢������MQ�O�5M�������F�A�i���?��M���x,�����S̳���M�X�ac0b@�A���?��������A4��?�����_#����������/����11���w�����0��
L��?"���o����?������6#�������8���?�#��*�����F��o����o��F��_���?6��o�]���G���]����b��#��\$�L�&q�g	��Y��"q�0�L�&I*�� H\�%�fB.�"+����������Գ������?�����������_��sM��J���u��X�\J��޵u��f�w~E��G�h��7Q�(� ���]@E�׷V%;�h�*��]�|�H"��ZN���Zs������1x�O�.{�4YN�45�lH���ǵ�j<�.�'�dr�3gS����2��S-���("��i���d4�,�#�r4�ь�7T}���}>��}�Ϧ�X7�rV�*�j��T�/x�Ї�?���m����_Q���;����_w�������1����������?:C���t�>������ ������? ��������l������'��G ��c�?������?�� ����?:��[����A�Gg��?� ��a���$u���x3���m��"O׵\�*/]����f���_����:��� �#��MƫG�Ѳ�W���t�Iw�^����$�Z	v)��4t�Ko�)3��<����|�����ڴ1k�_���z��a^���O֬F���hw8ۗ��$4\�ֆ=Z�XTmu��e.�2��l�jЂ�q������":��T6|ʮ�L;�s'7dˇ)���6��]�����c��?:��[����A�Gw��ѐ���S1J�1�`�p�xL�6��!�{X�����Cc?�zx����_C��t�ߙ��,
^q�[�s�'w�B0���)��.�+��9lWY:����?�����L�	��'&�Q-:�6�2B�Lw�ڂ?۳����v*b��F�	c1Ƽ�Si4�]k�N�5��x/���q����������q�6�'���>~A��x�[��~����������>�?������i-|�#�#r�0t@�C:b�D�!�c,����SW��`(��	$�h���A��D����?�h����3yY�⹞e	�m�t�٘�QoJ\�pj����19�|�4����zǬ�G��l���KK~	���I�"����2��$
u=U"b<?9~f�"ܒ�&%��E��RӁ�{/�p�G��_p�������_�u��a�}���翭��/M���_�&ܬ.�'7��Q1SL��Du7��f�{�k$���/��Y��1yi�����/�{�$���������-_ЫoM~��}nY[���K˚�����`��;�&��.;�㚷�M?A�"�
,o�;���Xg^F�X�g=����ư�M�u���Y���7����U6B�|���;q�aoMav�<���$���7�$��<�tj����<���dm���a�_CT@|���L!��Lg.fӄB���>�Y��f�+2Ts�Q&�m(,�p�Q��bG��x�+��0���$�|E&��ă���`�������?�@��_�������
��������?�����w����e8�������w�?4��Z�[�?���O0{��ck��V9�9<2X���}�����������~��}����8�<� �*�<�<!��aZ���Ys�
?.'YV�Q�5-�1\1� 
�Jd��9YN��NDs�"�y�+_f��ɸ�A�Ϩ����������1>��6cY�6x�"�F�U^f'��&]~��|�,g��Fa�"�z�8�e6���F6�h7{&|y��MH����O�<��"�S^�5�9��u�LeK���A�����j��,5WaDR�{���.�tM!+6f�Da?��=w��"��;o��}������
ڸ���������������w�6��8$�7�>����[���#��� �������������냃����PY楍�i�����s�.�W���y7�"o�Ll��vɷ��W���q���u��u^ܲ~�w����X`>�ұ���r�L�,�̆�l����w�L)�S�\�0��s���IM��&Q+���GkS-rL���Bu>�2�K�Ɨl���:7�˳:��c 3�s��H�u5�9��`҄Z2=fGD�r��쨜�~�7�~���WC�\񒟰Gi ���i8]�
F�w���ҕ�H#zNI[�I+�MEڛ���c~���S[��T_Sl��7cSg�L�hF�D��?z��
��v�N��~����������ko�L���7	��$��
�-Ur'�d�����w�m�����w�C+)���Ri4��B	���FF�$۱yT��ZIs�,n��_��#bt�����C	�ذ�fZ5�bY5yy�e��T��;��TJh9�b��2c��T�%��?�7�1�R�~�Ä��M���̇J2�������E
_��1T�I�0�lZ0"?�c��
�\��U�Ȍ��*w��ġ�($�sE�)O��]�2�@����@�w� ��`������_���?`�����@���C��_�6�V�7�n�����Q�j��i��b���t݊�?Y�_�rC[_���	�?Sf̧�76\#o�|�����Ds���<��12GжTL}�v�omT.ݢY�e'+�OP&�#ku�p���:0oy��Nb 3{G��qì��d���:��]�7F���v���8��f>��d�m�H���ȉ�;ֺ��;�wW}3#��Up�US�p(dϳ�hH��a��g$�9��
p��m����{��������~�@�߃�'� ��� �?��'���q�z����Gg��;G����x�C�M��wN1s�|:����(T���iL��ЭK�Zq��+Zvc�������),�Y�w��ي�F�pGI��ݟch��?w���ժVYRE{C����n��n3�;����o������
���e�WO�D��^1\V#Gi\,Q٪k}��8_�Ւ,�{��MQ� Ϥ�F�[ݵ;�a�D[��xϳ��_� |�>迫��_:B��*M@�cO�>����c�Gh��A�o����� �?���?��ө������������}ɮ�%��C����������O
� ���v��n��#����w��Bܟ�Ҁ��@W�v�����w�����OP�k	=�P�m��������� ��@���@����צ�;����?����c��@��t����w��?6���?������/����`&� ��c�^�?������@���8h�������������f��?Y��=�UNb��Vcev������~��/���iƍ8WB�~ν{��u��A�U�y�yB�3*ô8�sS!��<(~\N��.��kZ&,c�b�Ε���s��n흈�.<E��bW��b��qɃuN�B`/��\���e��'��'6cY���ě�*/��YY�.?�N��\���\��X��C�e��2��S]#�C��ݯ9XU����g[Dx�K��8G0�n2��l�ZB6>h�Qy�ryZ-ؔ��*�H�~�ԓ@��.�)d�ƌ�H"��s��:_��߿�^�?�A�+��m]�<:Wuq������l��������[A���L�0!�xc8AQ^�����"d�!I�^�Ga@�q4D� #�֐""�Pz����W���C���S�=������W�nL����$���/��V��Q�6'!�w;��DNa���H}��k����u��dNuP
m�R.�{3��{+_�y�&���U����48���o�q�N���%_NC��؂��nq�7[Tx��ٟ4W����I*�ω����=��_���������4�� �y{�6��_�(�_����=����V����?AT� �������?A��t�� �s ���9�w��`��%��Ah7h������V �?A�'������>8���VЩ�!P������z����������z���?a(��m �?��'��򟺭�?���[A���@u��?����w��@�SK�	�?x���^��+���ެ�_n�����.	.e��g�^l,��t�����Q����H_����l�M�������0ʯ��~yVyA��V=aE\ݞp��A6W�S���1%��&2����6F�ʚ0Gs6��PmK�t%!�}��E�旎��3�7m�N�RKU�m��ٲ�o��cu�M��֕ �j�S]W_J������\b��z���4��WG.�������j��->���#������#l5��p)��8��%�S��Y���^��'6e�̼�gPL@F�w�4ۚcb�	V�!q����U�| ��#�B�!4�����?�9�������������o+��G�Gġ�1�h8�H��bt�T�$�S��7]2����0P�b�I�!P��>�����������ߙ��C�<��`�ʊ8B�s�w�ω=UY����T�6g>�?-��?�7�2�T��"�I����{?�Cٞ���l9���q|���`��8��4�Mj'����z��[O]���3���^�����ԣ�G�Y���x����w�F��v�����t�^���|Oi���}��CU������tW�6�OWF�z���'TE���{�G��vf6�=wvf�
�3iD0�ef��Ǯ��l�^~�ˏz���\/Wٮ*�l���J�QBP�%���ϐ�I��"R�A|D �X�P�	���HH+�*���~��lfJ|Zj��=�֭S��s�9�^Gv�I�&7�ۑQG�(��P0Us�)�^�����y�vDQ#�GPa�}-�~����=�"r$���＼��N��͈��U�+X4y)��坕�@u��6��+���Ǒb�q���������m;v#�j����Fw����Ն=M5�ad)��YHH�fڊt��K�y��ّ�ضMۈ��Q�j���1=o�E���G�,Np�/��pO(�tE��fO�w����6�-�)'��K'��������#�Z0����ȶ�����AS�W�!+}�J�ܽR��K,_-PwW;G0�"�R�rU\�ߍi#%�9�N�﹇N u�^�-����i�������F��w��	F�GSq4�U"��>~�f��di����ڝ�4�G�1����5:�y��
f�}@�;�^0�P���;'(�ur�Ss�b������`4��N�S� /����|w �~��[�/n}��?�ع�b�^�Ӛ��������+-�$d���(�����`	='ᄢ�JՕx�+i-�`hK��x2�B7>���w?������~��t�������7ܗ��σ?<n
U���˸��Le�������@��@��'����/ہ� �%G0y��>����8(���9����r�u�P?�..�Ѓ�AW�.@`����A�S�����t%���*�8MV������Y����~���/_�ϧ?����������ק�B��ع<��˷��G��)�C�5����c��?�&���Ob����+ v�#�^��O���'���{��?���~��?�����Ž7:֧���H�"����|l�ܵs�\����s����5mS}�EK�u%�1��P�L
Sa]N�rR�R����v:�ēXJAn��T:�%$�X;��"��/��+ߕ��3��?p~����?�����|	�� �Q��A�>~\>z�&���'Hѿބ�u�@ƿr}��ρ���=��,���T~�����|��aq�͸|�{�(�jD�M�X\�w<'���88���Zsz|$q|�]����|G)��◩
>k�H=,�e���"|��<�\��s�_��9-����"	��!YO��&Ju�]g���lYD�cP�[�f��F�j��K(���<�������>ek�d��7ί�͗L4����?4s�<ٗ��jTs.������qI��^���}��It|�$u�oMc�t]��W}P){UOgX�d\�X�@�'l�'\o-��y��-�F\x��#���	���;Kv�5� I�$�ay6Jhi �hYoM整�O��1h���\3ek�Co@�/p���&�ӥ&�D�`�v˃�85�>!#�`��E�˔O�(��i�@��Ԥf�b�8ۉWH��u���&��œy��	��= x���C��h�R�1K��ʨqL��9ͱxz��_PrRO�.x_�0k������/xX0�Y��r{���Zui&�\E�����N)1R��<g�B�	��:/U2|����vK�JNl�`4�F5"!Jل1J�]�`�ظ��vx:+tZ*�� ���d��@�3)
,����k�#.w[T�Ig������\���1��Q���vR+�X"��B�%d�(�!ܽ���q��"Y�ǹh,;KL3�N��a�'Z.ɴf�U�eSU,חӦ���\��r�:�N��|��\�LXl�\��N���k8bQX*Lʴx癅~L�r�)���Qq2��V���!��,���J��Is�t�L4R5���1&�m��*%��F����^b:qY��#�ܙ�m�ј��X�k��K׫:`X��j�۽�1f9�|�Tf��8�5�	�gIo�X�.;�K�c�q.�I��g;8�`��\o�� �&�D&�L%g�`�_kI~]� X�ܙ*�K�ƃ�e�Շ�k�
�����u� հ�D��Ux�B���A���3Pt��?����i]��#=J�7�Ilo'��'��\z�Y�3lZ�g�4P��屁��l�ylԸ̷�]�<h�����>��'I�G�lE��R�y)I�C���a�J�.�0L�7��Y��&Z~N�:�)�n�?���yl�h"ۣ汁�D6�D&�7����Vi��|#-;Ê9����|��;�Y	�'�q>�sx�h��a��1W��m�l�T!�cr�,��z�j���2h��8Y�P�\���c�bb�S��<3����+-ljҚ���Tl� a!��'�<�@��(���݉,e��`E|ڂ.�緞ؾ.^���Ux�0��r����W���
��&�k��d���Ճ5���n���x�
��+��T>�x��G��J"�/
M�'�Q:Vd���z7���Y��cH�7��<��~���r�B����XQ�g,�ڭ�Ԧ���HЬ��^vy�IU9�VA:�ΏM�6���0��b��4� ���P��R�����a�9A�X;����z]���|�e�^Hۜ�٩���q�=�t�_���2���9ob������T���o6ho�
1/{vel��Ѩ�*V��,���KSgj�$�Y����F���X�1�X�2��~�Ӫ�����L1i��D�>��*���TŞ�*�@+�ѐӆ4!I�D7t:xٚ�j���Ԝ�%�4���<5�J�Q"_��y���͊�Ffn�\�ek`WzI�T�\��h?f�HQ��͹*7�73���()�6�J#��<]��&%Gմ�T��W�d�_��3h�\7�M�`#���0Q t�RYkh�ޔsDUpx�B��"���$��r�lE�ȿc*yT�����b�c�Yr�u_�MǮ:=S�A�AOo]����r��JG�U4�|���<
��6 {_C��_���{k��_�}���[����)fs������'�K��P��g�|��$k���y���&��`������j��ٝli~,Ӊc@�]��D�X;��-�3�E�<9����9����5�>���03h9��Mc�2���`,��J���H��7!%�;���V�@��z,�;�6�X��d�$\p�L�=�I��7������jÈg˽f+iZ��3F�۔:�
歪nV]%9��ˋe��F�%Jˠ(3���
�ZM�����| �l���Ri���96q���8��[��O�o�Ϙ�j=�D�=��C��ͯ^l~����W/Nue&����o���׼�W���={����go��\�gn��h�
���G�Ӽ��T;��}��_W�A��ƞ0s5�t<�9=g� E�!��o�5�Y���v��w���Gֺyz�#�}���_��@�x�+��9 ��#���8���~$�xg�7�f#�p^ �a�$�Lu��|Z+R��=�1m�N���CP��=��w��}S�H�k���ce�{Po�'<�BO�k{�Wա�y�=m����x��8�WD�O,�6��l`��6��l`�Y������ � 