import '../entities/epub_content_type.dart';
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../ref_entities/epub_content_file_ref.dart';
import '../ref_entities/epub_content_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';

EpubContentRef parseContentMap(EpubBookRef bookRef) {
  final EpubContentRef result = EpubContentRef(
    html: <String, EpubTextContentFileRef>{},
    css: <String, EpubTextContentFileRef>{},
    images: <String, EpubByteContentFileRef>{},
    fonts: <String, EpubByteContentFileRef>{},
    allFiles: <String, EpubContentFileRef>{},
  );

  for (final EpubManifestItem manifestItem in bookRef.schema!.package!.manifest!.items) {
    final String? fileName = manifestItem.href;
    final String contentMimeType = manifestItem.mediaType!;
    final EpubContentType contentType = getContentTypeByContentMimeType(contentMimeType);
    switch (contentType) {
      case EpubContentType.xhtml1_1:
      case EpubContentType.css:
      case EpubContentType.oeb1Document:
      case EpubContentType.oeb1Css:
      case EpubContentType.xml:
      case EpubContentType.dtbook:
      case EpubContentType.dtbookNcx:
        final EpubTextContentFileRef epubTextContentFile = EpubTextContentFileRef(
          epubBookRef: bookRef,
          fileName: Uri.decodeFull(fileName!),
          contentMimeType: contentMimeType,
          contentType: contentType,
        );
        switch (contentType) {
          case EpubContentType.xhtml1_1:
            result.html[fileName] = epubTextContentFile;
            break;
          case EpubContentType.css:
            result.css[fileName] = epubTextContentFile;
            break;
          case EpubContentType.dtbook:
          case EpubContentType.dtbookNcx:
          case EpubContentType.oeb1Document:
          case EpubContentType.xml:
          case EpubContentType.oeb1Css:
          case EpubContentType.imageGif:
          case EpubContentType.imageJpeg:
          case EpubContentType.imagePng:
          case EpubContentType.imageSvg:
          case EpubContentType.fontTruetype:
          case EpubContentType.fontOpentype:
          case EpubContentType.other:
            break;
        }
        result.allFiles[fileName] = epubTextContentFile;
        break;
      case EpubContentType.imageGif:
      case EpubContentType.imageJpeg:
      case EpubContentType.imagePng:
      case EpubContentType.imageSvg:
      case EpubContentType.fontTruetype:
      case EpubContentType.fontOpentype:
      case EpubContentType.other:
        final EpubByteContentFileRef epubByteContentFile = EpubByteContentFileRef(
          epubBookRef: bookRef,
          fileName: Uri.decodeFull(fileName!),
          contentMimeType: contentMimeType,
          contentType: contentType,
        );
        switch (contentType) {
          case EpubContentType.imageGif:
          case EpubContentType.imageJpeg:
          case EpubContentType.imagePng:
          case EpubContentType.imageSvg:
            result.images[fileName] = epubByteContentFile;
            break;
          case EpubContentType.fontTruetype:
          case EpubContentType.fontOpentype:
            result.fonts[fileName] = epubByteContentFile;
            break;
          case EpubContentType.css:
          case EpubContentType.xhtml1_1:
          case EpubContentType.dtbook:
          case EpubContentType.dtbookNcx:
          case EpubContentType.oeb1Document:
          case EpubContentType.xml:
          case EpubContentType.oeb1Css:
          case EpubContentType.other:
            break;
        }
        result.allFiles[fileName] = epubByteContentFile;
        break;
    }
  }
  return result;
}

EpubContentType getContentTypeByContentMimeType(String contentMimeType) {
  switch (contentMimeType.toLowerCase()) {
    case 'application/xhtml+xml':
      return EpubContentType.xhtml1_1;
    case 'application/x-dtbook+xml':
      return EpubContentType.dtbook;
    case 'application/x-dtbncx+xml':
      return EpubContentType.dtbookNcx;
    case 'text/x-oeb1-document':
      return EpubContentType.oeb1Document;
    case 'application/xml':
      return EpubContentType.xml;
    case 'text/css':
      return EpubContentType.css;
    case 'text/x-oeb1-css':
      return EpubContentType.oeb1Css;
    case 'image/gif':
      return EpubContentType.imageGif;
    case 'image/jpeg':
      return EpubContentType.imageJpeg;
    case 'image/png':
      return EpubContentType.imagePng;
    case 'image/svg+xml':
      return EpubContentType.imageSvg;
    case 'font/truetype':
      return EpubContentType.fontTruetype;
    case 'font/opentype':
      return EpubContentType.fontOpentype;
    case 'application/vnd.ms-opentype':
      return EpubContentType.fontOpentype;
    default:
      return EpubContentType.other;
  }
}
