(*

PURPOSE: Renames a set of files in a folder to match those in a reference folder

Version 1.0 created 5/11/2010 by Jack James, Surreal Road Ltd. sales@surrealroad.com

*)

try
	set refFldr to choose folder with prompt "Choose reference folder:"
on error number errorNo
	return errorNo
end try


try
	set tFldr to choose folder with prompt "Choose target folder:"
on error number errorNo
	return errorNo
end try

set refFileList to my getSortedFiles(refFldr)
set tFileList to my getSortedFiles(tFldr)

if (count of refFileList) is not equal to (count of tFileList) then
	set message to "The number of files in the target folder (" & (count of tFileList) & ") doesn't match the number of files in the reference folder (" & (count of refFileList) & ")." & return & "Would you like to proceed anyway?"
	if button returned of (display dialog message buttons {"Yes", "No"} default button 2) is "No" then return -128
end if


repeat with i from 1 to (count of tFileList)
	
	set ref_file_name to item i of refFileList
	set t_file_name to item i of tFileList
	
	set the_source to ((tFldr & t_file_name) as string) as alias
	set the_ref to ((refFldr & ref_file_name) as string) as alias
	
	tell application "System Events"
		set info to info for the_ref
		set newname to (name of info)
		set name of the_source to newname
	end tell
	
	--set result to result & newname
	
end repeat

--return result

on getSortedFiles(source_folder)
	tell application "System Events"
		set item_list to get the name of every disk item of source_folder
	end tell
	return my quicksort(item_list)
end getSortedFiles


-- quicksort function from http://macscripter.net/viewtopic.php?id=24766
on quicksort(theList)
	--public routine, called from your script
	script bs
		property alist : theList
		
		on Qsort(leftIndex, rightIndex)
			--private routine called by quickSort. 
			--do not call from your script!
			if rightIndex > leftIndex then
				set pivot to ((rightIndex - leftIndex) div 2) + leftIndex
				set newPivot to Qpartition(leftIndex, rightIndex, pivot)
				set theList to Qsort(leftIndex, newPivot - 1)
				set theList to Qsort(newPivot + 1, rightIndex)
			end if
			
		end Qsort
		
		on Qpartition(leftIndex, rightIndex, pivot)
			--private routine called by quickSort. 
			--do not call from your script!
			set pivotValue to item pivot of bs's alist
			set temp to item pivot of bs's alist
			set item pivot of bs's alist to item rightIndex of bs's alist
			set item rightIndex of bs's alist to temp
			set tempIndex to leftIndex
			repeat with pointer from leftIndex to (rightIndex - 1)
				if item pointer of bs's alist ² pivotValue then
					set temp to item pointer of bs's alist
					set item pointer of bs's alist to item tempIndex of bs's alist
					set item tempIndex of bs's alist to temp
					set tempIndex to tempIndex + 1
				end if
			end repeat
			set temp to item rightIndex of bs's alist
			set item rightIndex of bs's alist to item tempIndex of bs's alist
			set item tempIndex of bs's alist to temp
			
			return tempIndex
		end Qpartition
		
	end script
	
	if length of bs's alist > 1 then bs's Qsort(1, length of bs's alist)
	return bs's alist
end quicksort