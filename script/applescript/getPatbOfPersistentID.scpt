FasdUAS 1.101.10   ��   ��    k             l     ��  ��    j dosascript ~/Developpement\ web/mp3-library/applescript/getPatbOfPersistentID.scpt "CFF2A82AE23A635A"     � 	 	 � o s a s c r i p t   ~ / D e v e l o p p e m e n t \   w e b / m p 3 - l i b r a r y / a p p l e s c r i p t / g e t P a t b O f P e r s i s t e n t I D . s c p t   " C F F 2 A 8 2 A E 2 3 A 6 3 5 A "   
�� 
 i         I     �� ��
�� .aevtoappnull  �   � ****  o      ���� 0 arg  ��    k     &       l     ��������  ��  ��        O     #    k    "       l   ��������  ��  ��        r         n        1    ��
�� 
strq  n        1    ��
�� 
psxp  l     ����   e     ! ! n     " # " 1    ��
�� 
pLoc # l    $���� $ 6    % & % n     ' ( ' 4   �� )
�� 
cTrk ) m   	 
����  ( 4    �� *
�� 
cLiP * m    ����  & =    + , + 1    ��
�� 
pPIS , n    - . - 4   �� /
�� 
cobj / m    ����  . o    ���� 0 arg  ��  ��  ��  ��    o      ���� 0 songlocation songLocation   0 1 0 l  ! !��������  ��  ��   1  2 3 2 l  ! !�� 4 5��   4if (get class of (first track of library playlist 1 whose persistent ID is "CFF2A82AE23A635A")) is file track then set loc to quoted form of POSIX path of ((get location of --(first track of library playlist 1 whose persistent ID is "CFF2A82AE23A635A")) as text)    5 � 6 6 i f   ( g e t   c l a s s   o f   ( f i r s t   t r a c k   o f   l i b r a r y   p l a y l i s t   1   w h o s e   p e r s i s t e n t   I D   i s   " C F F 2 A 8 2 A E 2 3 A 6 3 5 A " ) )   i s   f i l e   t r a c k   t h e n   s e t   l o c   t o   q u o t e d   f o r m   o f   P O S I X   p a t h   o f   ( ( g e t   l o c a t i o n   o f   - - ( f i r s t   t r a c k   o f   l i b r a r y   p l a y l i s t   1   w h o s e   p e r s i s t e n t   I D   i s   " C F F 2 A 8 2 A E 2 3 A 6 3 5 A " ) )   a s   t e x t ) 3  7 8 7 l  ! !��������  ��  ��   8  9 : 9 l  ! !�� ; <��   ; ! display dialog the location    < � = = 6 d i s p l a y   d i a l o g   t h e   l o c a t i o n :  >�� > l  ! !��������  ��  ��  ��    m      ? ?�                                                                                  hook  alis    0  HD                         ��+AH+     n
iTunes.app                                                        ��K��        ����  	                Applications    ��1      �K�|       n  HD:Applications: iTunes.app    
 i T u n e s . a p p    H D  Applications/iTunes.app   / ��     @�� @ L   $ & A A o   $ %���� 0 songlocation songLocation��  ��       �� B C��   B ��
�� .aevtoappnull  �   � **** C �� ���� D E��
�� .aevtoappnull  �   � ****�� 0 arg  ��   D ���� 0 arg   E 
 ?���� F������������
�� 
cLiP
�� 
cTrk F  
�� 
pPIS
�� 
cobj
�� 
pLoc
�� 
psxp
�� 
strq�� 0 songlocation songLocation�� '�  *�k/�k/�[�,\Z��k/81�,E�,�,E�OPUO� ascr  ��ޭ