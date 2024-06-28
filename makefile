.PHONY: adguard gateway

adguard:
	@(cd adguard && ./create-iso.sh)

gateway:
	@(cd gateway && ./create-iso.sh)