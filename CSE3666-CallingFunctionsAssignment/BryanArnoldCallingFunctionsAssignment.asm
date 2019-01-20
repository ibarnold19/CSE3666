#  search
#  Linear Search Algorithm
#
#		Determines if the requested value is present in an array.
#
#  Parameters:
#		$a0:  the address of an array.
#		$a1:  the length of the array.
#		$a2:  the data to search for.
#
#  Results:
#		$v0:  0+ the index where the data was found. 
#			  -2 if an error occurs.
#			  -1 if the data is not found.
#####################################################################################

		
search:	
		#  Testing for bad parameters.
		lui		$t0, 0x1000
		blt		$a0, $t0, search_OutOfMemoryRange
		sll		$t1, $a1, 2
		addu	$t1, $a0, $t1
		blt		$t1, $t0, search_ArrayTooLarge
		sll		$t0, $a0, 30
		bne		$t0, $zero, search_NotWordAligned
		blez	$a1, search_ArrayTooSmall

		#  Initializing loop parameters.
		move	$t0, $a0		#  Address of current element to search
		sll		$t1, $a1, 2
		add		$t1, $t0, $t1	#  End of the array
		
		#  Iteratively searching through the array by incrementing the address.
search_loop:
		beq		$t0, $t1, search_NotFound
		lw		$t2, 0 ($t0)
		beq		$t2, $a2, search_Found
		addi	$t0, $t0, 4
		j		search_loop
		
		#  Return -1 if the data is not found.
search_NotFound:
		li		$v0, -1
		jr		$ra
		
		#  Return the index if the data is found.
search_Found:
		#  Convert the address into an index.
		sub		$v0, $t0, $a0
		srl		$v0, $v0, 2
		jr		$ra
		
		#  We could provide separate error codes for each of these conditions if we wanted.
search_OutOfMemoryRange:		#  The array is not in a valid part of memory.
search_ArrayTooLarge:			#  The array ends outside of a valid part of memory.
search_ArrayTooSmall:			#  The array length is less than 1.
search_NotWordAligned:			#  The array is not word aligned.
		li		$v0, -2
		jr		$ra
		

#############################################################################################
#                               	Generic Test Suite										#
#																							#
#  Padraic Edgington                                                          20 Oct, 2016	#
#																							#
#																							#
#  v. 1		Initial release  (It appears to work.)											#
#				Implemented print functions:												#
#					Print_Integer_Array														#
#					Print_Raw_Integer_Array													#
#					Print_Hexadecimal														#
#				Implemented assertion functions:											#
#					Assert_Equal_Integer													#
#					Assert_Not_Equal_Integer												#
#					Assert_Greater_Than_Integer												#
#					Assert_Less_Than_Integer												#
#					Assert_Greater_Than_Equal_Integer										#
#					Assert_Less_Than_Equal_Integer											#
#					Assert_Equal_Array														#
#					Assert_Null																#
#					Assert_Not_Null															#
#					Assert_Error															#
#					Assert_Equal_Long														#
#					Assert_Not_Equal_Long													#
#############################################################################################

main:	addi	$sp, $sp, -4		#  Make space for $ra on stack
		sw		$ra, 0 ($sp)		#  Store the return address on the stack

#############################################################################################
#									Functionality Tests										#
		li		$v0, 4
		la		$a0, type1
		syscall
#############################################################################################
	#Test #1
	#1602712035 is in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 1602712035
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 1
	la $a3, test1
	jal Assert_Greater_Than_Equal_Integer

	.data
test1: .asciiz "1602712035 is in the array."
	.text

#############################################################################################
	#Test #2
	#1041046135 is in the array
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 1041046135
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 2
	la $a3, test2
	jal Assert_Greater_Than_Equal_Integer

	.data
test2: .asciiz "1041046135 is in the array."
	.text

#############################################################################################
	#Test #3
	#-1194480622 is in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, -1194480622
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 3
	la $a3, test3
	jal Assert_Greater_Than_Equal_Integer

	.data
test3: .asciiz "-1194480622 is in the array."
	.text

#############################################################################################
	#Test #4
	#736562662 is in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 736562662
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 4
	la $a3, test4
	jal Assert_Greater_Than_Equal_Integer

	.data
test4: .asciiz "736562662 is in the array."
	.text

#############################################################################################
#Test #5
#-803840256 is in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, -803840256
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 5
	la $a3, test5
	jal Assert_Greater_Than_Equal_Integer

	.data
test5: .asciiz "-803840256 is in the array."
	.text

#############################################################################################
#Test #6
#0 is not in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 0
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 6
	la $a3, test6
	jal Assert_Less_Than_Integer

	.data
test6: .asciiz "0 is not in the array."
	.text

#############################################################################################
#Test #7
#42 is not in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 42
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 7
	la $a3, test7
	jal Assert_Less_Than_Integer

	.data
test7: .asciiz "42 is not in the array."
	.text

#############################################################################################
#Test #8
#1492 is not in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, 1492
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 8
	la $a3, test8
	jal Assert_Less_Than_Integer

	.data
test8: .asciiz "1492 is not in the array."
	.text

#############################################################################################
#Test #9
#-96 is not in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, -96
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 9
	la $a3, test9
	jal Assert_Less_Than_Integer

	.data
test9: .asciiz "-96 is not in the array."
	.text

#############################################################################################
#Test #10
#-8 is not in the array.
#############################################################################################	

	jal setSavedRegisters
	la $a0, array
	li $a1, 1024
	li $a2, -8
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 10
	la $a3, test10
	jal Assert_Less_Than_Integer

	.data
test10: .asciiz "-8 is not in the array."
	.text

##############################################################################################
		.data
array:	.word -784561419, -4033406, -2103011957, 564929546, 152112058, -32343104, -1607568878, 268830360, 1763988213, 578848526, -82152831, -698389847, -148054226, 950422373, 1908844540, 1452005258, -1265546186, 142578355, 1583761762, 1816660702, -1764468408, 1339965000, -420557374, -1250732387, 1962617717, -1970678116, 310281170, 981016607, 908202274, -923029575, -2050117803, 675678546, -1098145198, 1040470160, -1235355279, -1239567166, -1468137014, -1410429159, -1204379600, -2032732228, -788672402, 2080537739, 1636797501, -2034216, 2037904983, -1829272678, 1249751105, 30084166, 112252926, 1333718913, 880414402, 334691897, -957338815, 17084333, 1070118630, 2111543209, 1129029736, -1525250702, 198749844, 2123740404, -922850412, 667945179, 1235233343, 1413475797, -1939837674, -1163077982, 1361507145, -875156952, -541104792, -1651446937, 854777807, -1471294401, 1563137348, -1516896003, -934734716, 1294979669, -1627964709, -199527317, 806669383, -577153258, 1071953403, -664107659, 771361748, 1131385020, -597354781, -30122380, 1364828348, -1431073050, 1109863328, -1228030105, -1516284181, -305353343, 859474495, 167522376, 1094225558, 1963711766, 1257324636, 1729949323, 125753755, 1068698284, 1761594045, 2106609220, 1033190229, 946183933, 1100436279, 489306665, -1909922140, 658699819, -986949956, -1908969786, 105622857, 1976233741, 1535497010, 314176889, 1247500738, 2138106664, -1537888525, -1861506485, -324060825, 1944201130, -1928630794, -1753427381, -9984361, 224898482, 1457988276, -2106813059, -639848152, 979144237, 1279857832, -1583257133, -201030036, -1995073876, 2121869254, -1789507459, 1847263294, -1320509663, -855163558, 1672773492, 225684598, -1798109909, 611619631, -301944419, -786569280, 1663733971, 758566080, 1653863133, 1701066037, -512083935, -951153580, -1692389630, 629577870, -570873826, 361301181, -1620532319, 1443899064, -190170604, 140754167, -64024298, 447458027, 743917836, -1476652145, 1332110941, 266033703, 308176090, 130356650, -1220769824, -1201575252, 1602712035, 1856287253, -918997051, -1180095233, 370413632, 1435286098, 645351481, 908917276, -1854598858, 1599412846, -1794866567, 790131292, -610445806, -242303360, 1566488352, 295035953, -131524097, -1297041646, 678068969, -627306174, 1273385972, -739172382, 762012623, 1091375739, 1765680277, -56787935, -888376474, -497721040, 388618876, -2134273733, 349961032, 1392360403, -715942206, 604490212, -717143366, -1973504645, -504545241, -1109231355, -2065306710, 1128575466, 884862908, -964210168, -1100799058, 681073659, 800341641, 2006864675, -1675331075, 1577889182, -719811344, -2034850512, -605825418, 1657848984, -1652587065, -1416482732, -1195014216, 468844464, -160603665, -184327456, 1904558184, 1937194892, -1157364805, -651271598, 820242909, -1226594565, -906218373, -59364231, -1679851923, 1555770904, 1520951990, 1047053830, 1663094463, -346502252, 1077597088, -1298022979, -1063992687, 2019388652, 865275198, 2046271241, -1131346666, 269072378, -2041526542, 277763586, 1114595358, -1615150074, 988885471, 922982460, 477046426, 1161679484, -1344875298, 2088879880, -778060795, 1403601752, 1184069822, -763937836, -1253653944, -935793126, 2117925252, 1529768389, 1253051929, 1829668776, -1616200941, 2138924913, -1147667488, 447212163, 1069119222, -503262637, 804904386, -714621884, 1700215583, 904016717, 74539975, 1288558083, 1746888271, 437611701, 781576281, 1166365552, -1728633628, -2110380, -218164816, -326059249, -1237621245, 2074623641, -641329932, 586217310, -1083661067, -1690523318, -991743077, 50953535, 2118693299, 460196852, -939702954, 500727351, 1681849672, 113995187, 1200937601, -1202405434, 312936130, -378884272, -1733255880, -581025596, -2054532388, 637144400, 1946468041, -1070713157, -2052411973, -1769982777, 945834669, -1489768179, 1879274691, -502807176, 37879558, 1205870756, -786947112, -1589233561, -1160753919, -1124889740, 9055729, -2147071544, -506920971, -1872694204, 1228026268, 1275162816, 1385450594, 128490357, 678715088, -1828502893, -1579503555, 420067866, 396072989, 1729810791, -148898453, 389936193, 1010939382, 794725144, 633726173, -727174014, 248988111, 1254549356, 1989964616, 1425389196, -2092608349, -1464553890, -496039914, -852001128, 269966252, -1487320954, 1794971636, 1602977220, 1360381486, 1805272988, 554730358, -35069756, -2126227205, 442942697, -550349675, -727641223, 1232342342, -574756454, 303505483, -761204710, 2136482547, -1481021466, -1243134019, -1464802601, -1137494784, -1108854283, 1063305342, -161123065, 2026873438, 94687021, 42670911, -2089515575, 200274097, -1110624916, 1216199867, 1941807482, 1902652464, -154708641, 1934749011, -1668715901, 1041046135, -1038406980, 2005577300, 367040511, -1732675725, -115710211, 394550850, -580566374, -1198105820, -565170416, -766658183, 1483426196, 821348673, 2057501468, -1153577340, 631596202, -1969315523, -726215668, -1994788460, 257777076, -839291607, -1441058483, 223950412, -1974251708, 250378269, -737133359, 927098460, 315421373, 1957400381, 725633141, -949558012, 1114863797, 1830809043, 1922707457, -509205225, -890215809, -1860134596, 1359584120, 860423718, -1315010767, 888063953, 641814761, 180527770, -978104659, -282007367, 28566252, 1045558574, -163360559, 215968520, 362234156, -2046851360, -1225878084, -891366487, 1812984601, 1768934064, -287381136, 1240758160, 13887765, -780352187, -467593257, -953768581, 1982839159, 2033151304, -11064474, -550776762, 726223056, -389720661, 1875803225, 2030522753, -1472892608, -969485016, 1691268105, -1261100451, 1716543028, 1555574049, -1633873800, 1979855811, -2043033361, 1276056752, -953726028, 1892612984, -2100121242, 486586963, -1802143706, 593230942, 775986230, 1255789287, -1976867694, -1238704216, 158332807, -1843037746, -920831805, 372847709, 1128359579, 373993639, -1875847344, 829613207, -1346756133, -1970801477, 160722663, 1444930279, 765460462, -514471874, 592264489, 316670611, -1952828331, 1439591408, -932749006, -1434064643, 1116562887, -1261288144, 1381679779, 1291533463, 1962666710, -2072593782, 1215751045, -725731232, 1611254503, 1171727980, -1237482812, -1031179632, -1229255020, 781477153, 1881176626, -525924526, 1193467712, -1451062206, -857300938, -2134249692, 419274206, -1527887399, -287603786, 1325555048, -107230662, -228060286, -995217554, 154249616, 1941800223, 1157563946, 705258893, 860757803, 1310317854, 1898329708, -803737723, 312822728, -887965418, 1029352733, -831056944, -1553804259, -1589383484, -1650621661, 683012156, 948328240, -1638100135, 1644147624, -1441091443, 822059867, 753937406, 1604103884, 1756360543, -894320103, -1492201266, -2026776240, -510323352, -1285040059, 394432056, 1840177440, -1643201372, 1205254585, -743485055, -1437029790, -1772458183, -619203230, 1234994787, -835783336, 186529857, 1329960799, -1972569846, 1078548606, 113242357, -1873639790, -988866415, 211880652, 847202265, 1034020264, -1920891810, 755993425, -1820557391, 1885945103, -706940477, -968765865, 747273957, -1122405384, -230363637, 2036147813, -755383808, -1433802439, -991088710, -1909127129, 734771685, 804646316, 1158163327, 2080435695, -1839155934, 2060318701, 1223319334, -1721113565, -953630435, -1087622524, 1654544724, 1227774824, 1779567885, -53541841, -352388339, -1507007387, 90390016, 1235487669, -1889697600, -198069036, 2121644059, -1862960144, -1645960493, 355642145, -296846217, -770385913, 919279000, 789586853, -1829475260, 220701650, -1347743017, 1329892616, -565047795, 1219039514, -1288085107, 281458735, -494467805, -720925871, -2072848945, -187666261, -1607417088, -1034081188, -593107904, -432775934, 1412535194, 1694757183, 772470279, 689128388, -2029412982, -795064354, -1449431846, -1724164328, 1947307958, -267599393, 1910806179, -436077517, -273231844, -216179364, -881935079, -1314913731, -2146157775, 1497338125, 2040525958, -1182905222, -2093086021, -622682281, -1291867832, -485270271, -585790258, -1030040793, 1707537043, 1104985157, -603104876, 1898692192, -1971916202, 736562662, -1994653380, -1194480622, 302436891, 1288467611, 1981059467, -649188660, 1609399619, -876804921, -627124144, 536318325, -1254311942, -1750499365, 424476355, 1601741596, 246832728, -1617679652, -1459544989, 1127786001, 850991343, 2067806155, -528755146, 1001927094, -493898415, -1052658559, 1560596676, 1681618985, -1731968902, -810141774, -1639575300, 1746361319, -744131173, -256224470, 735255465, -340890690, -193597246, -1127955207, 1966689481, 1576556523, 207036082, -1957620627, -890082138, -922772894, -1981194422, 1511011541, -360713537, 152017013, -1989870640, 1003233114, -506785252, -1556883667, -1627648561, -219115784, -375014672, -360279792, 955697805, -573605403, 1892740917, 1925356403, -764321607, 57355987, 500963211, -482704021, -1174264300, -946572856, -1646724691, -1344001736, -1388718424, -99359733, 1976120064, 569029796, -1090072899, 836657553, -41862739, -265443048, 1167446730, -1130710602, 1225943621, 978942573, -407013239, -265273563, -923356158, -1646840114, 341670719, 780349063, 1249088385, -1468980090, 1409751402, -801825753, -1840520301, -1293067754, 894695004, -181373259, -1546847937, -483688834, 337072564, -743698761, -84650843, -1437662580, 1656016234, -1239117103, -220826177, -1592283320, -391447008, -1586857400, 1303194166, 676764765, 1073839, -877942825, 530027902, 664548902, -360777775, 1118172394, 1598501076, 1353136139, -738610529, -443531017, 787984702, -679970639, -1641123954, 350845053, -1754199844, 341795141, -163387738, -1442735993, 347703279, 304754275, -657748938, 1191420956, -44693414, -2077637819, -675954812, -1974577213, 1618600250, 100602741, -332137670, -969128766, -984925721, -2092610062, -1884701596, 1855854724, 1586666379, 1893433651, -82072326, -1216496334, -1289175346, -649870187, -1565636576, 178175659, 1878759843, -681903272, -2059944979, 1229007963, 1217716121, -870323911, 2025817426, -1753656842, -803840256, 834075061, 1476080952, 527792572, -1152350256, 990164480, -756105491, 1101804820, 254185979, 2139277356, -1240989211, -658688726, 1588526078, -1029281238, -1094242830, -989533335, 1714292212, -1400325910, 286242900, -1904272331, 1104137642, 1729447649, -1691820180, 1739535876, -1962641642, -371449326, 975963350, -1248216743, -7827480, -1407540843, -1089593959, -1465847230, 324806067, 1090404329, -1532028337, 2016187695, 188074317, 562585328, 1185556641, -314787445, -1372927629, -1079114007, 946979886, -1472042192, 803185936, 1852384677, -1997811073, -1495479311, 1756284627, -1977229152, 1335401093, 674337096, -1395411499, -298426282, -1280217358, 283034558, -813005160, -484659055, -1569304719, 744192370, -629383828, 571653166, -1113504939, 1782231829, 563269281, 1274600369, -1907996378, 363976120, -1363013866, 614822572, 1661454733, 449226294, -788451052, -867916523, -1674502609, 505585754, -1038417444, 321182353, -404538233, 2030404657, 1191957414, -825930217, 947528907, 578915297, -2139951181, 557136361, 374100253, 1716551606, 1064892772, -2012130787, -2089079861, 735861059, 2088833463, -409973338, 1520195389, -945740715, -178018975, -640777229, -709857813, -2124275262, -190916900, 1431760441, 871040163, -1163745700, -255329330, -1039286699, 1537348827, -20928681, -1528036078, -1214910706, -1867391146, 1698622741, 491269657, -1337815042, -291639973, 1665870563, -1395968411, 350910601, -917055057, 56558544, -1537235170, -1291947718, -1274490812, 1103562767, 266867533, -1056496605, 101050052, -2120825847, -33673252, -916990051, -11934063, 1649319944, -1887424796, 1186270608, 506638155, 853299114, 528018288, -924607106, -862240763, 33304936, 746516661, 864441540, 877624554, 549536499, -1782480423, 1718378202, 1877264374, -387842140, -814665773, 1222420918, -1332554509, 1897386667, 565602854, 870635873, 1837265416, 2093005006, 2069832336, 421542850, 546177829, -557672085, 2022730805, 114777545, 1045010491, 1474827040, 7636789, -368589247, 825140914, -400088528, -2059618476, -85799924, 1363271078, 1633012431, -1690369191, 1475584955, 363136592, -1354973338, -899940975, -1524984797, -1714984874, -917113784, 1926697291, 1309179303, 198769522, 525328917, -1355334909, -455621934, 857890368, 1404166316, 1175685399, -935779659, -1383646612, -963106945, 150684895, 1830720677, -745641994, 1721173678, 1541682359, -567838631, 1378619663, -637321497, 427125659, 87651116, 816648775, 1111028388, -886060490, 1198529401
length:	.word 1024
null: .word 0
		.text


#############################################################################################
#									Error Checking Tests									#
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, type2
		syscall
#############################################################################################
#Test #101
#Array is null.
#############################################################################################

	jal setSavedRegisters
	la $a0, null
	li $a1, 0
	li $a2, -8
	jal search

	move $a0, $v0
	li $a1, 0
	li $a2, 101
	la $a3, test101
	jal Assert_Null

	.data
test101: .asciiz "Array is null."
	.text

#############################################################################################
#Test #102
#The array ends outside of a valid part of memory.
#############################################################################################

	jal setSavedRegisters

	la $a0, null
	la $a1, array
	la $a2, 102
	la $a3, test102
	jal Assert_Equal_Array

	.data
test102: .asciiz "The array ends outside of a valid part of memory."
	.text

#############################################################################################
#Test #103
#The array length is less than 1.
#############################################################################################

	jal setSavedRegisters

	la $a0, null
	la $a1, array
	la $a2, 103
	la $a3, test103
	jal Assert_Equal_Array

	.data
test103: .asciiz "The array length is less than 1."
	.text

#############################################################################################
#Test #104
#The array is not word aligned.
#############################################################################################

	jal setSavedRegisters

	la $a0, null
	la $a1, array
	la $a2, 104
	la $a3, test104
	jal Assert_Equal_Array

	.data
test104: .asciiz "The array is not word aligned."
	.text

#############################################################################################
#										All Tests Completed									#
Skip_Parameter_Validation_Tests:
		.data
type1:	.asciiz	"----------Starting functionality tests.----------\n"
type2:	.asciiz	"----------Starting parameter checking tests.----------\n"
finish:	.asciiz	"----------Testing completed.----------\n"
		.text
		li		$v0, 4
		la		$a0, finish
		syscall
		lw		$ra, 0 ($sp)		#  Load return address
		addi	$sp, $sp, 4			#  Pop the stack
		jr		$ra


##############################################################################################
##############################################################################################
##																							##
##									Printing Functions										##
##																							##
##############################################################################################
##############################################################################################


		#######################################################################
		#						Print Integer Array
		#
		#  Parameters:
		#	$a0:  The array of integers to display.
		#
		#		Assumes that the first element in the data structure is the
		#  length of the array.
		#######################################################################
Print_Integer_Array:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -20
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$t3, 12 ($sp)
		sw		$v0, 16 ($sp)

		#  Check for a valid array, print a simple error message if this is not an array.
		lui		$t0, 0x1000
		blt		$a0, $t0, PA_Outside_of_Memory
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, PA_Not_Word_Aligned

		move	$t0, $a0				#  Store the array address in $t0
		lw		$t1, 0 ($t0)			#  Store the length in $t1
		#  First, print the length
		li		$v0, 4
		la		$a0, Length
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall

		#  If the length is zero, just quit now.
		beqz	$t1, PA_Exit

		#  Next, print the contents of the array.
		li		$v0, 4
		la		$a0, Contents
		syscall

		li		$t2, 1					#  Loop counter is in $t2.
PA_Loop:
		bgt		$t2, $t1, PA_Exit

		li		$v0, 4
		la		$a0, Space
		syscall
		li		$v0, 1
		sll		$t3, $t2, 2				#  One variable is provided for in $t3.
		add		$t3, $t0, $t3
		lw		$a0, 0 ($t3)
		syscall

		addi	$t2, $t2, 1
		j		PA_Loop
		.data
Length:	.asciiz	"Length:  "
Contents:	.asciiz	"  Contents:"
Space:	.asciiz	"  "
		.text


		#  If the "array" is not within data memory, don't try to display it.
PA_Outside_of_Memory:
		li		$v0, 4
		la		$a0, PAOM
		syscall
		j		PA_Exit
		.data
PAOM:	.asciiz	"The provided \"array\" is not inside the viable range for data and thus cannot be displayed."
		.text

		#  If the "array" is not word aligned, don't try to display it.
PA_Not_Word_Aligned:
		li		$v0, 4
		la		$a0, PANWA
		syscall
		j		PA_Exit
		.data
PANWA:	.asciiz	"The provided \"array\" is not word aligned and thus cannot be displayed."
		.text

PA_Exit:#  We've reached the end of the print function, so restore all the registers that we changed
		#  and return to the calling function.
		li		$v0, 4
		la		$a0, nl
		syscall
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		lw		$v0, 16 ($sp)
		addi	$sp, $sp, 20
		jr		$ra


		#######################################################################
		#					Print Raw Integer Array
		#
		#  Parameters:
		#	$a0:  The array of integers to display.
		#	$a1:  The length of the array.
		#######################################################################
Print_Raw_Integer_Array:
		#  Saving the existing data on the stack in case someone is carelessly
		#  calling this function.
		addi	$sp, $sp, -20
		sw		$t0,  0 ($sp)
		sw		$t1,  4 ($sp)
		sw		$t2,  8 ($sp)
		sw		$t3, 12 ($sp)
		sw		$v0, 16 ($sp)

		#  Check for a valid array, print a simple error message if this is not an array.
		lui		$t0, 0x1000
		blt		$a0, $t0, PA_Outside_of_Memory
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, PA_Not_Word_Aligned

		move	$t0, $a0				#  Store the array address in $t0
		move	$t1, $a1				#  Store the length in $t1
		#  First, print the length
		li		$v0, 4
		la		$a0, Length
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall

		#  If the length is zero, just quit now.
		beqz	$t1, PRIA_Exit

		#  Next, print the contents of the array.
		li		$v0, 4
		la		$a0, Contents
		syscall

		li		$t2, 0					#  Loop counter is in $t2.
PRIA_Loop:
		bge		$t2, $t1, PRIA_Exit

		li		$v0, 4
		la		$a0, Space
		syscall
		li		$v0, 1
		sll		$t3, $t2, 2				#  One variable is provided for in $t3.
		add		$t3, $t0, $t3
		lw		$a0, 0 ($t3)
		syscall

		addi	$t2, $t2, 1
		j		PRIA_Loop


PRIA_Exit:#  We've reached the end of the print function, so restore all the registers that we changed
		#  and return to the calling function.
		li		$v0, 4
		la		$a0, nl
		syscall
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		lw		$v0, 16 ($sp)
		addi	$sp, $sp, 20
		jr		$ra


		#######################################################################
		#  Print Hexadecimal Number
		#
		#      This function takes a 32-bit integer as a parameter and prints
		#  it to the console in hexadecimal format.
		#
		#  Parameters:
		#  $a0:  32-bit number
		#######################################################################
		.data
hex:	.ascii	"0123456789ABCDEF"
nbsp:	.asciiz	" "
		.text
Print_Hexadecimal:
		addi	$sp, $sp, -4
		sw		$s0, 0 ($sp)
		move	$s0, $a0


		#  Use a mask to select four bits at a time; move the selected four bits
		#  into the least significant bit positions and use them as an index to
		#  select a hexadecimal character from the hex array and print the character.
		li		$t0, 0				#  Counter
HexLoop:
		bge		$t0, 32, HexEndLoop
		li		$a0, 0xF0000000
		srlv	$a0, $a0, $t0		#  Create a mask for the current 4 bits
		and		$a0, $a0, $s0		#  Apply the mask
		li		$t1, 28
		sub		$t1, $t1, $t0
		srlv	$a0, $a0, $t1		#  Shift the selected 4 bits into the LSB positions
		la		$t1, hex
		add		$a0, $t1, $a0
		lbu		$a0, 0 ($a0)		#  Read the indexed character from the string
		li		$v0, 11
		syscall						#  Print the selected character
		addi	$t0, $t0, 4			#  Increment to the next four bits
		bne		$t0, 16, HexLoop
		li		$v0, 4
		la		$a0, nbsp
		syscall						#  Print a space after the first four characters
		j		HexLoop


HexEndLoop:
		lw		$s0, 0 ($sp)
		addi	$sp, $sp, 4
		jr		$ra


##############################################################################################
##############################################################################################
##																							##
##									Assertion Functions										##
##																							##
##############################################################################################
##############################################################################################


		#######################################################################
		#  Assert equality for integers
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Equal_Integer:
		#  Integers are easy to compare
		bne		$a0, $a1, AEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value did not match the expected result.
AEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AEIF
		j		Results
		#  Error description print routine.
AEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AEIF1
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Expected
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		jr		$ra


		.data
AEIF1:	.asciiz	"The observed value did not match the expected result.\n"
Observed:	.asciiz	"Observed:  "
Expected:	.asciiz	"Expected:  "
		.text

		#######################################################################
		#  Assert inequality for integers
		#	$a0:  Observed
		#	$a1:  Undesired
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Not_Equal_Integer:
		#  Integers are easy to compare
		beq		$a0, $a1, ANEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value did not match the expected result.
ANEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ANEIF
		j		Results
		#  Error description print routine.
ANEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, ANEIF1
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Undesired
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall
		jr		$ra


		.data
ANEIF1:	.asciiz	"The observed value should not match the undesired value.\n"
Undesired:	.asciiz	"Undesired:  "
		.text

		#######################################################################
		#  Assert greater than for integers
		#	$a0:  Observed
		#	$a1:  Greater than
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Greater_Than_Integer:
		#  Integers are easy to compare
		ble		$a0, $a1, AGTIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not greater than the minimum value.
AGTIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AGTIF
		j		Results
		#  Error description print routine.
AGTIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, AGTIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
AGTIF1:	.asciiz	"The result ("
AGTIF2:	.asciiz	") should be greater than "
AGTIF3:	.asciiz	".\n\n"
		.text

		#######################################################################
		#  Assert less than for integers
		#	$a0:  Observed
		#	$a1:  Less than
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Less_Than_Integer:
		#  Integers are easy to compare
		bge		$a0, $a1, ALTIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not less than the minimum value.
ALTIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ALTIF
		j		Results
		#  Error description print routine.
ALTIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, ALTIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
ALTIF2:	.asciiz	") should be less than "
		.text

		#######################################################################
		#  Assert greater than or equal to for integers
		#	$a0:  Observed
		#	$a1:  Greater than or equal to
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Greater_Than_Equal_Integer:
		#  Integers are easy to compare
		blt		$a0, $a1, AGTEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not greater than or equal to the minimum value.
AGTEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, AGTEIF
		j		Results
		#  Error description print routine.
AGTEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, AGTEIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
AGTEIF2:	.asciiz	") should be greater than or equal to "
		.text


		#######################################################################
		#  Assert less than or equal to for integers
		#	$a0:  Observed
		#	$a1:  Less than or equal to
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Less_Than_Equal_Integer:
		#  Integers are easy to compare
		bgt		$a0, $a1, ALTEIFail

		#  Correct solution.
		li		$a0, 1
		j		Results



		#  Failed because the observed value was not less than the minimum value.
ALTEIFail:
		addi	$sp, $sp, -8					#  Storing the observed and expected values on the stack.
		sw		$a0, 0 ($sp)
		sw		$a1, 4 ($sp)

		li		$a0, 0
		la		$a1, ALTEIF
		j		Results
		#  Error description print routine.
ALTEIF:	lw		$t0, 0 ($sp)					#  We can now retrieve the observed and expected values to print.
		lw		$t1, 4 ($sp)
		addi	$sp, $sp, 8

		li		$v0, 4
		la		$a0, AGTIF1
		syscall
		li		$v0, 1
		move	$a0, $t0
		syscall
		li		$v0, 4
		la		$a0, ALTEIF2
		syscall
		li		$v0, 1
		move	$a0, $t1
		syscall
		li		$v0, 4
		la		$a0, $AGTIF3
		syscall
		jr		$ra


		.data
ALTEIF2:	.asciiz	") should be less than or equal to "
		.text

		#######################################################################
		#  Assert equality for 64-bit integers
		#	$a0:  Observed upper 32 bits
		#	$a1:  Observed lower 32 bits
		#	$a2:  Expected upper 32 bits
		#	$a3:  Expected lower 32 bits
		#	$sp-4:  Test #
		#	$sp-8:  Test description
		#######################################################################
Assert_Equal_Long:
		bne		$a0, $a2, AELFail		#  Comparing longs is almost as easy as ints.
		bne		$a1, $a3, AELFail

		#  Correct solution
		li		$a0, 1
		lw		$a2, -4 ($sp)
		lw		$a3, -8 ($sp)
		j		Results

		#  Failed because the long integers did not match.
AELFail:
		addi	$sp, $sp -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Expected upper 32 bits
		sw		$a3, 12 ($sp)			#  Expected lower 32 bits
		#  Test # is at 16 ($sp)
		#  Test description is at 20 ($sp)

		li		$a0, 0
		la		$a1, AELF
		lw		$a2, 16 ($sp)
		lw		$a3, 20 ($sp)
		j		Results
		#  Error description print routine.
AELF:	li		$v0, 4
		la		$a0, AEIF1				#  "The observed value did not match the expected result.\n"
		syscall
		la		$a0, Observed			#  "Observed:  "
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nl
		syscall

		la		$a0, Expected			#  "Expected:  "
		syscall
		lw		$a0, 8 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 12 ($sp)
		jal		Print_Hexadecimal
		lw		$v0, 4
		la		$a0, nbsp
		syscall
		syscall

		addi	$sp, $sp, 24
		jr		$ra

		#######################################################################
		#  Assert inequality for 64-bit integers
		#	$a0:  Observed upper 32 bits
		#	$a1:  Observed lower 32 bits
		#	$a2:  Undesired upper 32 bits
		#	$a3:  Undesired lower 32 bits
		#	$sp-4:  Test #
		#	$sp-8:  Test description
		#######################################################################
Assert_Not_Equal_Long:
		bne		$a0, $a2, ANELPass		#  Comparing longs is almost as easy as ints.
		bne		$a1, $a3, ANELPass
		j		ANELFail

ANELPass:
		#  Correct solution
		li		$a0, 1
		lw		$a2, -4 ($sp)
		lw		$a3, -8 ($sp)
		j		Results

		#  Failed because the long integers matched.
ANELFail:
		addi	$sp, $sp -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Undesired upper 32 bits
		sw		$a3, 12 ($sp)			#  Undesired lower 32 bits
		#  Test # is at 16 ($sp)
		#  Test description is at 20 ($sp)

		li		$a0, 0
		la		$a1, ANELF
		lw		$a2, 16 ($sp)
		lw		$a3, 20 ($sp)
		j		Results
		#  Error description print routine.
ANELF:	li		$v0, 4
		la		$a0, ANEIF1				#  "The observed value should not match the undesired value.\n"
		syscall
		la		$a0, Observed			#  "Observed:  "
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nl
		syscall

		la		$a0, Undesired			#  "Undesired:  "
		syscall
		lw		$a0, 8 ($sp)
		jal		Print_Hexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall
		lw		$a0, 12 ($sp)
		jal		Print_Hexadecimal
		lw		$v0, 4
		la		$a0, nbsp
		syscall
		syscall

		addi	$sp, $sp, 24
		jr		$ra


		#######################################################################
		#  Assert equality for integer arrays with included size parameter
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Equal_Array:
		#  1.  Check for a valid observed array.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AEA_Failed_Outside_of_Memory
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AEA_Failed_Not_Word_Aligned	#  The results should be equal.
		#  2.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		beq		$a0, $a1, AEA_Failed_Cheating
		#  These should pass unless the student has done something catastrophic.

		#  Assume that the data inside the array has been changed improperly and use the expected data for the length of the array.
		li		$t0, 0
		lw		$t1, 0 ($a1)
AEA_Loop:
		bgt		$t0, $t1, AEA_End_Loop

		sll		$t9, $t0, 2
		add		$t2, $a0, $t9
		lw		$t2, 0 ($t2)
		add		$t3, $a1, $t9
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, AEA_Failed_Not_Equal

		addi	$t0, $t0, 1
		j		AEA_Loop
AEA_End_Loop:
		#  All elements are equal, so the arrays are equivalent.
		li		$a0, 1			#  Correct result.
		j		Results

AEA_Failed_Outside_of_Memory:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFOM		#  Description of failure.
		j		Results
		.data
AEAFOM:	.asciiz	"The array pointer is no longer within the data memory range.\nThis is bad, I do not know how you managed to accomplish this.\n"
		.text

AEA_Failed_Not_Word_Aligned:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNWA	#  Description of failure.
		j		Results
		.data
AEAFNWA:	.asciiz	"The array pointer is no longer word aligned.\nThis is bad, I do now know how you managed to accomplish this.\n"
		.text

AEA_Failed_Cheating:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFC		#  Description of failure.
		j		Results
		.data
AEAFC:	.asciiz	"Cheating is bad, mmmkay?\nQuit trying to game the test suite.\n"
		.text

AEA_Failed_Not_Equal:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)	#  Store the observed array on the stack.
		sw		$a1, 4 ($sp)	#  Store the expected array on the stack.
		sw		$ra, 8 ($sp)	#  Store the return address on the stack.

		beq		$t0, $zero, AEA_Failed_Wrong_Length
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFNE		#  Description of failure.
		j		Results
AEAFNE:	li		$v0, 4
		la		$a0, AEAFNE1
		syscall
		j		AEA_Print_Array
		.data
AEAFNE1:	.asciiz	"The observed array does not match the expected array.\n"
		.text

AEA_Failed_Wrong_Length:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEAFWL		#  Description of failure.
		j		Results
AEAFWL:	li		$v0, 4
		la		$a0, AEAFWL1
		syscall
		.data
AEAFWL1:	.asciiz	"The length of the array has been changed.\nYou should not need to modify the first element in the array.\n"
		.text

		#  Print out the contents of the array to show the student what (s)he did wrong.
AEA_Print_Array:
		lw		$t0, 0 ($sp)	#  Restore the observed array from the stack.
		lw		$t1, 4 ($sp)	#  Restore the expected array from the stack.

		li		$v0, 4
		la		$a0, Observed
		syscall
		move	$a0, $t0
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, Expected
		syscall
		move	$a0, $t1
		jal		Print_Integer_Array

		lw		$ra, 8 ($sp)	#  Restore the return address from the stack.
		addi	$sp, $sp, 12
		jr		$ra






		#######################################################################
		#  Assert equal n-dimensional matrix of integers
		#	$a0:  Observed
		#	$a1:  Expected
		#	$a2:  Test #
		#	$a3:  Test description
		#
		#		The expected format has a top-level array where the first
		#  integer specifies the number of dimensions in the matrix.  The next
		#  n integers specify the size of each dimension.  The last value in
		#  the array is a pointer to the first level of the matrix.  Each level
		#  of the matrix contains pointers to an array at the next lower level
		#  until the last, which contains the actual data for that row.
		#######################################################################
Assert_Equal_nD_Matrix:
		#  1.  Check for a valid observed array.
		#      It should be a pointer to the data region of memory.
		lui		$t0, 0x1000								#  All data should be above 0x1000 0000 and not negative.
		blt		$a0, $t0, AEA_Failed_Outside_of_Memory
		#      It should also be word aligned, since the first value is an integer.
		li		$t0, 0xFFFFFFFC
		and		$t0, $a0, $t0						#  Set the last two bits to zero, to force it to be word aligned.
		bne		$a0, $t0, AEA_Failed_Not_Word_Aligned	#  The results should be equal.
		#  2.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		beq		$a0, $a1, AEA_Failed_Cheating
		#  These should pass unless the student has done something catastrophic.

		lw		$t0, 0 ($a0)
		lw		$t1, 0 ($a1)
		#  3.  Check to see that both data structures report the same number of dimensions.
		bne		$t0, $t1, AEnM_Mismatched_Dimensions

		#  4.  Iterate over the dimension sizes to make sure they all match.
		sll		$t0, $t0, 4
		li		$t1, 4
AEnM_Dimension_Loop:
		bgt		$t1, $t0, AEnMDL_End
		add		$t2, $a0, $t1
		add		$t3, $a1, $t1
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		bne		$t2, $t3, AEnM_Mismatched_Sizes
		addi	$t1, $t1, 4
		j		AEnM_Dimension_Loop
AEnMDL_End:

		#  5.  Check to make sure the student isn't trying to pass off the expected array as the observed array.
		add		$t2, $a0, $t1
		add		$t3, $a0, $t1
		lw		$t2, 0 ($t2)
		lw		$t3, 0 ($t3)
		beq		$t2, $t3, AEA_Failed_Cheating

		#  6.  Iterate over the dimensions loading data and comparing it.
		#	   Data should always be equal, but pointers should never be equal.

#  TODO:  Add code to programmatically walk across the pair of n-dimensional arrays and compare the results.

		#  Failed because the number of dimensions did not match.
AEnM_Mismatched_Dimensions:
		addi	$sp, $sp, -8
		sw		$t0, 0 ($sp)		#  Observed number of dimensions
		sw		$t1, 4 ($sp)		#  Expected number of dimensions

		li		$a0, 0				#  Incorrect result
		la		$a1, AEnMMD_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMMD_Print_Failure:
		li		$v0, 4
		la		$a0, AEnMMD
		syscall
		la		$a0, Observed
		syscall
		li		$v0, 1
		lw		$a0, 0 ($sp)
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		la		$a0, Expected
		syscall
		li		$v0, 1
		lw		$a0, 4 ($sp)
		syscall
		li		$v0, 4
		la		$a0, nl
		syscall
		syscall

		addi	$sp, $sp, 8
		jr		$ra

		#  Failed because the size of one or more dimensions did not match.
AEnM_Mismatched_Sizes:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)			#  Observered matrix
		sw		$a1, 4 ($sp)			#  Expected matrix
		sw		$ra, 8 ($sp)			#  Return address

		li		$a0, 0					#  Incorrect result
		la		$a1, AEnMMS_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMMS_Print_Failure:
		li		$v0, 4
		la		$a0, AEnMMS
		syscall

		la		$a0, Observed
		syscall
		lw		$a0, 0 ($sp)
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, Expected
		syscall
		lw		$a0, 4 ($sp)
		jal		Print_Integer_Array

		li		$v0, 4
		la		$a0, nl
		syscall
		syscall

		lw		$ra, 8 ($sp)
		addi	$sp, $sp, 12
		jr		$ra

		#  Failed because one or more elements did not match the expected value.
AEnM_Data:
		addi	$sp, $sp, -12
		sw		$a0, 0 ($sp)			#  Observed matrix
		sw		$a1, 4 ($sp)			#  Expected matrix
		sw		$ra, 8 ($sp)			#  Return address

		li		$a0, 0					#  Incorrect result
		la		$a1, AEnMD_Print_Failure
		j		Results
		#  Display reason for failure.
AEnMD_Print_Failure:
#  TODO:  Add code to walk over the matrices and display the data.

		.data
AEnMMD:	.asciiz	"The number of dimensions in the matrix is incorrect.\n"
AEnMMS:	.asciiz	"The size of the matrix is incorrect.\n"
AEnMD:	.asciiz	"The data in the matrix does not match the expected result.\n"
		.text






		#######################################################################
		#  Assert null pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Null:
		bne		$t0, $zero, AN_Failed

		li		$a0, 1			#  Correct result.
		j		Results

AN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANF:	.asciiz	"Null pointer expected.\n"
		.text





		#######################################################################
		#  Assert valid pointer
		#	$a0:  Observed
		#	   :  Expect a null pointer (0).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Not_Null:
		beq		$t0, $zero, ANN_Failed

		li		$a0, 1			#  Correct result.
		j		Results

ANN_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, ANF		#  Description of failure.
		j		Results
		.data
ANNF:	.asciiz	"Null pointer not expected.\n"
		.text





		#######################################################################
		#  Assert error
		#	$a0:  Observed
		#	   :  Expect an error signal (0x8000 0001).
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Assert_Error:
		li		$t0, 0x80000001
		bne		$a0, $t0, AE_Failed

		li		$a0, 1			#  Correct result.
		j		Results

AE_Failed:
		li		$a0, 0			#  Incorrect result.
		la		$a1, AEF		#  Description of failure.
		j		Results
		.data
AEF:	.asciiz	"The parameters were not parsable, the function should have returned an error (0x8000 0001).\n"
		.text





		#######################################################################
		#  Results
		#
		#  Display the results of the test.
		#	$a0:  Pass (1) or fail (0).
		#	$a1:  Description of failure if needed.
		#	$a2:  Test #
		#	$a3:  Test description
		#######################################################################
Results:
		bnez		$a0, checkSavedRegisters
Res1:	move		$t0, $a0
		move		$t1, $a1
		move		$t2, $a2
		move		$t3, $a3
		#  Print the header.
		li		$v0, 4
		la		$a0, R1
		syscall
		li		$v0, 1
		move	$a0, $t2
		syscall

		bnez		$t0, RPass

		#  Failed the test.
		li		$v0, 4
		la		$a0, RF
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		blt		$t1, 0x10000000, RPrintFunction
		move	$a0, $t1			#  Displaying a simple error message.
		syscall
		la		$a0, nl
		syscall
		jr		$ra
RPrintFunction:						#  Calling a print function for extra detail.
		jr		$t1

		#  Passed the test.
RPass:	li		$v0, 4
		la		$a0, RP
		syscall
		move	$a0, $t3
		syscall
		la		$a0, nl
		syscall
		jr		$ra

		.data
R1:		.asciiz	"Test #"
nl:		.asciiz	"\n"
RP:		.asciiz	" passed:  "
RF:		.asciiz	" failed:  "
		.text




		#  Set Saved Registers
		#######################################################################
setSavedRegisters:
		li		$s0, 14
		li		$s1, 73
		li		$s2, 69
		li		$s3, 46
		li		$s4, 79
		li		$s5, 92
		li		$s6, 37
		li		$s7, 96
		li		$t0, 14
		li		$t1, -72
		li		$t2, 12331
		li		$t3, 18
		li		$t4, 456
		li		$t5, 09876
		li		$t6, 6789
		li		$t7, 3443
		li		$t8, 2343
		li		$t9, 98
		li		$v0, 3876
		li		$v1, 3443
		li		$a0, 23453
		li		$a1, 34432
		li		$a2, 543
		li		$a3, -234543
		jr		$ra

		#  Check Saved Registers
		#######################################################################
checkSavedRegisters:
		bne		$s0, 14, regFail
		bne		$s1, 73, regFail
		bne		$s2, 69, regFail
		bne		$s3, 46, regFail
		bne		$s4, 79, regFail
		bne		$s5, 92, regFail
		bne		$s6, 37, regFail
		bne		$s7, 96, regFail
		j		Res1

regFail:
		.data
rf:		.asciiz	"Your function returned the correct value, but has changed the saved registers.\nYou must follow the conventions and restore the state of any saved register ($s0-$s7) when you're finished with it.\n"
		.text
		li		$a0, 0
		la		$a1, rf
		j		Res1