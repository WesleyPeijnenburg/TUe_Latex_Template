
import os
import sys
# Loading the pyPdf Library
from pyPdf import PdfFileWriter, PdfFileReader

# Creating a routine that appends files to the output file
def append_pdf(input,output):
	[output.addPage(input.getPage(page_num)) for page_num in range(input.numPages)]

def main(Anim_name,Frames):
	output  = PdfFileWriter() # Creating an object where pdf pages are appended to

	for F in Frames:# For each frame, collect it in the output
		append_pdf(PdfFileReader(open(F+'.pdf','rb')),output) # Append these pages
	
	# Write all output to a single pdf
	output.write(open(Anim_name,"wb")) # Writing all the collected pages to a file


if __name__ == '__main__':
	print 'Running python: collecting pdf images into a single pdf document'
	Anim_name = sys.argv[1]
	Frames = str.split(sys.argv[2],'.pdf')
	main(Anim_name,[F for F in Frames if F])# Filter empty elements
	print 'Done! Here is some LaTeX code to get the animation working:'
	print '\n\\begin{figure}[H]\n' \
		  '\\begin{center}  %\\usepackage{animate} \n%' \
		  '\\animategraphics[<options>]' \
		  '{<fps>}{<filename>}{<first frame>}{<last frame>}\n' \
		  '\\animategraphics[autoplay,loop,height=0.8\\textheight]{3}{' \
		  + 'MathAnimation/' + Anim_name[:-4] + \
		  '}{}{}\n\\end{center} \\end{figure}\n'


