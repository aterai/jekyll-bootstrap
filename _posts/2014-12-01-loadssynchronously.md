---
layout: post
category: swing
folder: LoadsSynchronously
title: JEditorPaneに読み込んだHTMLを画像に変換する
tags: [JEditorPane, HTMLEditorKit, HTML, ImageIO, Graphics]
author: aterai
pubdate: 2014-12-01T00:02:34+09:00
description: JEditorPaneに画像付きのHTMLを読み込み、描画が完了した段階で全体のスクリーンショットを撮る方法をテストします。
image: https://lh5.googleusercontent.com/-JPZBF-3MA9o/VHskydE02OI/AAAAAAAANrs/7WXsb2t0ahg/s800/LoadsSynchronously.png
comments: true
---
## 概要
`JEditorPane`に画像付きの`HTML`を読み込み、描画が完了した段階で全体のスクリーンショットを撮る方法をテストします。

{% download https://lh5.googleusercontent.com/-JPZBF-3MA9o/VHskydE02OI/AAAAAAAANrs/7WXsb2t0ahg/s800/LoadsSynchronously.png %}

## サンプルコード
<pre class="prettyprint"><code>class ImageLoadSynchronouslyHTMLEditorKit extends HTMLEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new HTMLEditorKit.HTMLFactory() {
      @Override public View create(Element elem) {
        View view = super.create(elem);
        if (view instanceof ImageView) {
          ((ImageView) view).setLoadsSynchronously(true);
        }
        return view;
      }
    };
  }
  //@Override public Document createDefaultDocument() {
  //  Document doc = super.createDefaultDocument ();
  //  ((HTMLDocument) doc).setAsynchronousLoadPriority(-1);
  //  return doc;
  //}
}
</code></pre>

## 解説
上記のサンプルでは、タブを切り替えた後に`JEditorPane#setText(...)`で`HTML`の読み込みを行い、全体のスクリーンショットを縮小して画像にし、サムネイルとして右端の`JLabel`に表示しています。

- `default`タブ
    - デフォルトの`HTMLEditorKit`を使用
    - `<img>`タグの画像が非同期で読み込まれるため、スクリーンショットは文字のみ表示される
    - 文書の末尾までスクロールした後で、画像のサイズが決まる
- `<img width='%d' ...`タブ
    - デフォルトの`HTMLEditorKit`を使用
    - `<img>`タグに予めサイズを属性で指定しているので、スクリーンショット全体のサイズや、スクロールは正常だが、スクリーンショットに画像は表示されない
- `LoadsSynchronously`タブ
    - `HTMLEditorKit#getViewFactory()`と`ViewFactory#create(Element)`をオーバーライドし、`ImageView`に`setLoadsSynchronously(true)`を設定することで画像の読み込みを同期的に行う
    - スクリーンショットに画像がすべてロードされた状態で表示される

<!-- dummy comment line for breaking list -->

- - - -
- `JDK 11.0.2`、`JDK 8.0.202`から`ImageView`に`setLoadsSynchronously(true)`を設定すると画像が表示されなくなってしまった
    - `JDK 8.0.222`では修正されている
    - [&#91;JDK-8223384&#93; ImageView incorrectly calculates size when synchronously loaded - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8223384)
    - `OracleJDK`でも`OpenJDK`でも同じ状況
- `JDK 11.0.1`では正常に画像が表示される

		openjdk version "11.0.1" 2018-10-16
		OpenJDK Runtime Environment 18.9 (build 11.0.1+13)
		OpenJDK 64-Bit Server VM 18.9 (build 11.0.1+13, mixed mode)
- * 参考リンク [#reference]
- [ImageView#setLoadsSynchronously(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/ImageView.html#setLoadsSynchronously-boolean-)
- [setAsynchronousLoadPriority on JTextPane does not seem to work in 1.6 | Oracle Community](https://community.oracle.com/thread/1353113)
    - via: [java - JScrollPane does not update its scroll to go down to follow the caret position because of Image in JEditorPane - Stack Overflow](https://stackoverflow.com/questions/27044987/jscrollpane-does-not-update-its-scroll-to-go-down-to-follow-the-caret-position-b)

<!-- dummy comment line for breaking list -->

## コメント
