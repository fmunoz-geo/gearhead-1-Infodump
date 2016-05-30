Program infodump;
	{ Test program for the dumping item/mecha info to the wiki.}
	
	
	
uses Sysutils,gears,arenahq,ability,action,arenacfe,arenascript,backpack,damage,gearutil,ghchars,ghholder,
     ghmodule,ghparser,ghprop,ghswag,interact,menugear,randchar,rpgdice,skilluse,texutil,navigate,
     coninfo,conmap,conmenus,context,ghweapon;
const
	NumForm = 9;		{ The number of different FORMs which exist in the game.}

	GS_Battroid = 0;	{ Default form }
	GS_Zoanoid = 1;		{ Animal Form Mecha }
	GS_GroundHugger = 2;	{ Land Vehicle - Heavy Armor }
	GS_Arachnoid = 3;	{ Walker type tank }
	GS_AeroFighter = 4;	{ Fighter Jet type }
	GS_Ornithoid = 5;	{ Bird Form Mecha }
	GS_Gerwalk = 6;		{ Half robot half plane }
	GS_HoverFighter = 7;	{ Helicopter, etc. }
	GS_GroundCar = 8;	{ Land Vehicle - High Speed }
	 
	FormName: Array[ 0 .. ( NumForm - 1 ) ] of String = (
	'Battroid','Zoanoid','GroundHugger','Arachnoid','AeroFighter',
	'Ornithoid','Gerwalk','HoverFighter','GroundCar'
	);
var
    //N : Integer;
	MekList: GearPtr;
	ShopList: SAttPtr;
	F : TextFile;
	F2 :Text;
begin
	ShopList := CreateFileList( Design_Directory + Default_Search_Pattern );
	Assign (F,'dump.txt');
	rewrite(F);
	system.WriteLn(F, '==== MECHAS ====');

	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!Type');
	system.WriteLn(F, '!data-sort-type="number"|Mass');
	system.WriteLn(F, '!data-sort-type="number"|MV');
	system.WriteLn(F, '!data-sort-type="number"|TR');
	system.WriteLn(F, '!data-sort-type="number"|SE');
	system.WriteLn(F, '!data-sort-type="number"|Hands');
	system.WriteLn(F, '!data-sort-type="number"|Mounts');
	system.WriteLn(F, '!data-sort-type="number"|PV');
//	N := 0;
	while ( ShopList <> Nil ) do begin
		MekList := LoadGearPattern( ShopList^.Info , Design_Directory );

		while ( MekList <> Nil ) and ( MekList^.G = GG_Mecha ) do begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|' + FormName[MekList^.S]);
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|<nowiki>' + SgnStr(MechaManeuver(MekList)) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr(MechaTargeting(MekList)) + '</nowiki>' );
			system.WriteLn(F, '|<nowiki>' + SgnStr(MechaSensorRating(MekList)) + '</nowiki>');
			system.WriteLn(F, '|' + BStr( CountActiveParts( MekList , GG_Holder , GS_Hand ) ));
			system.WriteLn(F, '|' + BStr( CountActiveParts( MekList , GG_Holder , GS_Mount ) ));
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
			MekList := MekList^.Next;
		end;
		
		ShopList := ShopList^.Next;
	end;
	system.WriteLn(F, '|}');
	
	{ Get rid of the shopping list. }
	DisposeSAtt( ShopList );
	DisposeGear( MekList );

	system.WriteLn(F, '==== GUN - Small Arms ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|BV');
	system.WriteLn(F, '!data-sort-type="number"|MAG');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');

	//Guns;
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil ) 
	do begin
		if ( ( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Ballistic) and (  MekList^.V < 11) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_BurstValue ] + 1 ) + '</nowiki>');
			system.WriteLn(F, '|' + BStr( AmmoRemaining( MekList ) ) );
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');

	DisposeGear( MekList );

	system.WriteLn(F, '==== GUN - Heavy Weapons ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|BV');
	system.WriteLn(F, '!data-sort-type="number"|MAG');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');

	//Guns;
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil )
	do begin
		if ( ( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Ballistic) and (  MekList^.V > 11)) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_BurstValue ] + 1 ) + '</nowiki>');
			system.WriteLn(F, '|' + BStr( AmmoRemaining( MekList ) ) );
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');

	DisposeGear( MekList );
	
	//Beam guns
	system.WriteLn(F, '==== BeamGun - Small Arms ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|BV');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');

	//Guns;
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil )
	do begin
		if  (( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Ballistic) and (  MekList^.V < 11) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_BurstValue ] + 1 ) + '</nowiki>');
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');
	DisposeGear( MekList );

	//Beam guns
	system.WriteLn(F, '==== BeamGun - Heavy Weapons ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|BV');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');

	//Guns;
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil ) 
	do begin
		if (( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Ballistic) and (  MekList^.V > 11) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_BurstValue ] + 1 ) + '</nowiki>');
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');
	DisposeGear( MekList );
	
	//Missiles guns
	system.WriteLn(F, '==== Missile Launchers - Heavy Weapons ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|MAG');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');

	//Guns;
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil ) 
	do begin
		if ( ( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Ballistic) and (  MekList^.V < 11) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|' + BStr( AmmoRemaining( MekList ) ) );
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');
	DisposeGear( MekList );
	
	//Melee
	system.WriteLn(F, '==== Melee - Close Combat ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');
	
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil ) 
	do begin
		if ( ( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_Melee ) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|' + BStr( MekList^.V * 3) );
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');
	DisposeGear( MekList );
	
	//EMelee

	system.WriteLn(F, '==== Energy Melee - Close Combat ====');
	system.WriteLn(F, '{| class="article-table sortable"');
	system.WriteLn(F, '!data-sort-type="number"|Scale');
	system.WriteLn(F, '!Name');
	system.WriteLn(F, '!data-sort-type="number"|DC');
	system.WriteLn(F, '!data-sort-type="number"|Range');
	system.WriteLn(F, '!data-sort-type="number"|ACC');
	system.WriteLn(F, '!data-sort-type="number"|SPD');
	system.WriteLn(F, '!data-sort-type="number"|kg');
	system.WriteLn(F, '!data-sort-type="number"|DP');
	system.WriteLn(F, '!Effects');
	system.WriteLn(F, '!data-sort-type="number"|PV');
	
	Assign( F2 , PC_Equipment_File );
	Reset( F2 );
	MekList := ReadGear( F2 );
	Close( F2 );
	
	while ( MekList <> Nil ) 
	do begin
		if ( ( MekList^.G = GG_Weapon ) and ( MekList^.S = GS_EMelee ) ) then
		begin
			system.WriteLn(F, '|-');
			system.WriteLn(F, '|' + BStr( MekList^.Scale ));
			system.WriteLn(F, '|' + FullGearName( MekList ));
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Range ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + SgnStr( MekList^.Stat[ STAT_Accuracy ] ) + '</nowiki>');
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.Stat[ STAT_Recharge ] ) + '</nowiki>');
			system.WriteLn(F, '|' + MassString( MekList ) );
			system.WriteLn(F, '|<nowiki>' + BStr( MekList^.V * 3 ) + '</nowiki>');
			system.WriteLn(F, '|' + WeaponAttackAttributes( MekList ) );
			system.WriteLn(F, '|' + BStr( GearValue( MekList )));
		end;
		MekList := MekList^.Next;
	end;
		
	system.WriteLn(F, '|}');
	DisposeGear( MekList );
	
	
	System.Close (F);
end.

	//PC_Equipment_File = Design_Directory + 'PC_Equipment.txt';
	//Mek_Equipment_File = Design_Directory + 'Mek_Equipment.txt';
