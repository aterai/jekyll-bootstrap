---
layout: post
category: swing
folder: LoadsSynchronously
title: JEditorPaneに読み込んだHTMLを画像に変換する
tags: [JEditorPane, HTMLEditorKit, HTML, ImageIO, Graphics]
author: aterai
pubdate: 2014-12-01T00:02:34+09:00
description: JEditorPaneに画像付きのHTMLを読み込み、描画が完了した段階で全体のスクリーンショットを撮る方法をテストします。
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

- 左: `default`
    - デフォルトの`HTMLEditorKit`を使用
    - `<img>`の画像が非同期で読み込まれるため、スクリーンショットは文字のみ
    - 文書の末尾までスクロールした後で、画像のサイズが決まる
- 中: `<img width='%d' ...`
    - デフォルトの`HTMLEditorKit`を使用
    - `<img>`に予めサイズを属性で指定しているので、スクリーンショット全体のサイズや、スクロールは正常だが、スクリーンショットに画像は表示されない
- 右: `LoadsSynchronously`
    - `HTMLEditorKit#getViewFactory()`、`ViewFactory#create(Element)`をオーバーライドし、`ImageView`に、`setLoadsSynchronously(true)`を設定して、画像の読み込みを同期的に行うように変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ImageView#setLoadsSynchronously(boolean) (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/api/javax/swing/text/html/ImageView.html#setLoadsSynchronously-boolean-)
- [setAsynchronousLoadPriority on JTextPane does not seem to work in 1.6 | Oracle Community](https://community.oracle.com/thread/1353113)
    - via: [java - JScrollPane does not update its scroll to go down to follow the caret position because of Image in JEditorPane - Stack Overflow](http://stackoverflow.com/questions/27044987/jscrollpane-does-not-update-its-scroll-to-go-down-to-follow-the-caret-position-b)

<!-- dummy comment line for breaking list -->

## コメント