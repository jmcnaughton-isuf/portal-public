import { LightningElement, api, track } from 'lwc';

export default class Portal_ContentModuleMetadata extends LightningElement {
    @api metadataChange = () => {}
    @api referenceVar;
    @api metadataTemplate;

    @api
    get metadata() {
        return this._metadata;
    }

    set metadata(value) {
        this._isArray = Array.isArray(value);
        if (this._isArray) {
            this._metadata = Object.assign([], value);
        } else {
            this._metadata = Object.assign({}, value);
        }
        this.setMetadataList();
    }

    @track _isArray = false;
    @track _metadata = {};
    @track _metadataList = [];

    @track _defaultObject = {};
    @track _defaultObjectIsField = false;
    @track _objectList = [];

    setMetadataList() {
        if (this.metadataTemplate && this._metadata && !this._isArray) {
            this._metadataList = [];

            Object.keys(this.metadataTemplate).forEach(key => {
                let newMetadata = {}
                if (this._metadata[key]) {
                    newMetadata = {label: key, value: this._metadata[key], template: this.metadataTemplate[key]};
                } else {
                    newMetadata = {label: key, value: this.metadataTemplate[key], template: this.metadataTemplate[key]}

                    if (Array.isArray(newMetadata.value)) {
                        newMetadata.value = [];
                    } else if (typeof(newMetadata.value) === 'object') {
                        newMetadata.value = {};
                    } else {
                        newMetadata.value = "";
                    }
                }

                if (typeof(newMetadata.value) === 'object') {
                    newMetadata.isObject = true;
                } else {
                    newMetadata.isField = true;
                }

                this._metadataList.push(newMetadata);
            });
        } else if (this.metadataTemplate && this._metadata) {
            this._defaultObject = this.metadataTemplate[0];

            if (typeof(this._defaultObject) === 'object') {
                this._defaultObjectIsField = false;
            } else {
                this._defaultObjectIsField = true;
            }

            this._objectList = JSON.parse(JSON.stringify(this._metadata));
        }
    }

    handleAddToArray() {
        this._objectList.push(JSON.parse(JSON.stringify(this._defaultObject)));
        this.metadataChange(this._objectList, this.referenceVar);
    }

    handleRemoveFromArray(event) {
        let index = event.target.dataset.index;

        this._objectList.splice(index, 1);
        this.metadataChange(this._objectList, this.referenceVar);
    }

    handleInput = (event) => {
        if (this._isArray) {
            if (event.target.value === {} || event.target.value === [] || event.target.value === "") {
                delete this._objectList[event.target.dataset.index];
            } else {
                this._objectList[event.target.dataset.index] = event.target.value;
            }
            this.metadataChange(this._objectList, this.referenceVar);
            return;
        }

        if (event.target.value === {} || event.target.value === [] || event.target.value === "") {
            delete this._metadata[event.target.dataset.label];
        } else {
            this._metadata[event.target.dataset.label] = event.target.value;
        }

        this.metadataChange(this._metadata, this.referenceVar);
    }

    handleChange = (metadata, reference) => {
        let metadataString = JSON.stringify(metadata);
        if (metadataString === '{}' || metadataString === '[]' || metadata === "") {
            delete this._metadata[reference];
        } else {
            this._metadata[reference] = metadata
        }

        this.metadataChange(this._metadata, this.referenceVar);
    }
}