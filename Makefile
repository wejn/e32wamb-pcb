.PHONY: all images production clean

all: images production

images:
	kicad-cli sch export svg --output images ./project/e32wamb.kicad_sch
	mv images/e32wamb.svg images/schema.svg
	kicad-cli sch export pdf --output images/schema.pdf ./project/e32wamb.kicad_sch
	pdftocairo -singlefile -png -r 300 images/schema.pdf images/schema
	kicad-cli pcb render -w 3200 -h 1800 --output images/pcb-front.png ./project/e32wamb.kicad_pcb
	convert images/pcb-front.png -trim +repage images/pcb-front.png
	kicad-cli pcb render -w 3200 -h 1800 --side bottom --output images/pcb-back.png ./project/e32wamb.kicad_pcb
	convert images/pcb-back.png -trim +repage images/pcb-back.png
	# maybe:
	# kicad-cli pcb export svg --page-size-mode 2 -l "F.Cu,F.Silkscreen,F.Mask,Edge.Cuts,F.Courtyard,F.Cu" --mode-single --exclude-drawing-sheet --output a.svg ./project/e32wamb.kicad_pcb
	# inkscape --export-area-drawing --export-dpi=600 --export-type=png --export-background gray --export-filename=a.png a.svg

production:
	python3 -m jlc-fab-toolkit.plugins.cli --path project/e32wamb.kicad_pcb -t

clean:
	rm -rf project/production/
