// In this macro, we split the Local Z projection output stacks into cortical and yolk regions, and then 
// also separate the histone and jupiter channels and save them. So, in effect we create 4 timelapses.
// All are saved at 16-bit to save disk space, while retaining the dynamic range

print("\\Clear");
numFolders=getNumber("Number of conditions =", 8); // This should be double the number of genotypes

while (numFolders>0){
	path=getDirectory("Open the folder with LZPed hyperstacks");	print(path);
	
	numFolders=numFolders-1;
}

list=getInfo("log");
data_folders=split(list, "\n");

print("\\Clear");

folder=0;

while (folder<data_folders.length){ // While loop through genotypes and temperatures
	
	//folder=getDirectory("Choose a folder with movies");	files=getFileList(folder);

	files=getFileList(data_folders[folder]);
	
	file=0;
	setBatchMode(true); // this makes the code run much faster
	
	while(file<files.length){ // While loop over files
	
		if (endsWith(files[file], "_LZP.tif")>0){ // IF statement to pick Local Z Projected files
	
			open(data_folders[folder]+files[file]);		name=File.nameWithoutExtension;
			
			newName=substring(name, 0, indexOf(name,"_LZP"));		print(data_folders[folder]+newName);
	
			selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_cortical_DNA] duplicate channels=1 slices=1-8");
			selectWindow(newName+"_cortical_DNA");				run("Z Project...", "projection=[Sum Slices] all");
			selectWindow("SUM_"+newName+"_cortical_DNA");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			setMinAndMax(0,384);
			//save(data_folders[folder]+newName+"_cortical_DNA.tif");

			selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_yolk_DNA] duplicate channels=1 slices=9-17");
			selectWindow(newName+"_yolk_DNA");				run("Z Project...", "projection=[Sum Slices] all");
			selectWindow("SUM_"+newName+"_yolk_DNA");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			setMinAndMax(0,384);
			//save(data_folders[folder]+newName+"_yolk_DNA.tif");

			//selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_cortical_MT] duplicate channels=2 slices=1-6");
			//selectWindow(newName+"_cortical_MT");				run("Z Project...", "projection=[Sum Slices] all");
			//selectWindow("SUM_"+newName+"_cortical_MT");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			//save(data_folders[folder]+newName+"_cortical_MT.tif");

			//selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_yolk_MT] duplicate channels=2 slices=7-17");
			//selectWindow(newName+"_yolk_MT");				run("Z Project...", "projection=[Sum Slices] all");
			//selectWindow("SUM_"+newName+"_yolk_MT");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			//save(data_folders[folder]+newName+"_yolk_MT.tif");

			selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_apical_MT] duplicate channels=2 slices=1-6");
			selectWindow(newName+"_apical_MT");				run("Z Project...", "projection=[Sum Slices] all");
			selectWindow("SUM_"+newName+"_apical_MT");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			setMinAndMax(0,640);
			//save(data_folders[folder]+newName+"_apical_MT.tif");

			selectWindow(name+".tif");		run("Duplicate...", "title=["+newName+"_sub-apical_MT] duplicate channels=2 slices=7-12");
			selectWindow(newName+"_sub-apical_MT");				run("Z Project...", "projection=[Sum Slices] all");
			selectWindow("SUM_"+newName+"_sub-apical_MT");		run("Grays");		setMinAndMax(0, 65535);		run("16-bit");
			setMinAndMax(0,640);
			//save(data_folders[folder]+newName+"_sub-apical_MT.tif");
			
			run("Merge Channels...", "c2=[SUM_"+newName+"_cortical_DNA] c6=[SUM_"+newName+"_yolk_DNA] create");
			//rename(newName+"_DNA.tif");		save(data_folders[folder]+newName+"_DNA.tif");
			rename(newName+"_DNA");		run("RGB Color", "frames");
	
			//run("Merge Channels...", "c2=[SUM_"+newName+"_cortical_MT] c6=[SUM_"+newName+"_yolk_MT] create");
			//rename(newName+"_MT.tif");		save(data_folders[folder]+newName+"_MT.tif");
			//rename(newName+"_MT");		run("RGB Color", "frames");

			run("Merge Channels...", "c2=[SUM_"+newName+"_apical_MT] c6=[SUM_"+newName+"_sub-apical_MT] create");
			//rename(newName+"_MT.tif");		save(data_folders[folder]+newName+"_MT.tif");
			rename(newName+"_MT");		run("RGB Color", "frames");

			//run("Merge Channels...", "c2=[SUM_"+newName+"_cortical_MT] c4=[SUM_"+newName+"_cortical_DNA] c6=[SUM_"+newName+"_yolk_MT] create");
			//rename(newName+"_MT-cDNA.tif");		save(data_folders[folder]+newName+"_MT-cDNA.tif");

			//run("Merge Channels...", "c2=[SUM_"+newName+"_cortical_MT] c4=[SUM_"+newName+"_yolk_DNA] c6=[SUM_"+newName+"_yolk_MT] create");
			//rename(newName+"_MT-yDNA.tif");		save(data_folders[folder]+newName+"_MT-yDNA.tif");

			//run("Combine...", "stack1=["+newName+"_DNA] stack2=["+newName+"_MT] combine");		selectWindow("Combined Stacks");
			//rename(newName+"_DNA-MT.tif");			save(data_folders[folder]+newName+"_DNA-MT.tif");

			run("Combine...", "stack1=["+newName+"_DNA] stack2=["+newName+"_MT] combine");		selectWindow("Combined Stacks");
			rename(newName+"_DNA-spindle.tif");			save(data_folders[folder]+newName+"_DNA-spindle.tif");

			//run("Combine...", "stack1=[SUM_"+newName+"_cortical_DNA] stack2=[SUM_"+newName+"_yolk_DNA] combine");		selectWindow("Combined Stacks");
			//rename(newName+"_DNA.tif");			save(data_folders[folder]+newName+"_DNA.tif");

			close("*");
			
		} // IF statement to pick Local Z Projected files
		
		file=file+1;
	} // While loop over files
	
	run("Collect Garbage");		setBatchMode("exit and display");
	folder=folder+1;

} // While loop through genotypes and temperatures
exit();

