Program infodump;
	{ Test program for the dumping item/mecha info to the wiki.}
	
	
	
uses Sysutils,gears,arenahq,ability,action,arenacfe,arenascript,backpack,damage,gearutil,ghchars,ghholder,
     ghmodule,ghparser,ghprop,ghswag,interact,menugear,randchar,rpgdice,skilluse,texutil,navigate,
     congfx,coninfo,conmap,conmenus,context,ghweapon,ghintrinsic;
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
begin
	ShopList := CreateFileList( Design_Directory + Default_Search_Pattern );
	Assign (F,'dump.txt');
	rewrite(F);
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
	System.Close (F);
end.
