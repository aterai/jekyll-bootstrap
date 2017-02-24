---
layout: post
category: swing
folder: GetComponentsRecursively
title: Containerの子Componentを再帰的にすべて取得する
tags: [Container, Component, JFileChooser, JTable]
author: aterai
pubdate: 2017-02-06T14:11:50+09:00
description: Containerの子Componentを再帰的にすべて取得するメソッドを作成し、JFileChooserに配置されたJTableを取得します。
image: https://drive.google.com/uc?export=view&amp;id=1NedWhPhVuMDTwrHRaFdW-YXZjdH-019yuw
comments: true
---
## 概要
`Container`の子`Component`を再帰的にすべて取得するメソッドを作成し、`JFileChooser`に配置された`JTable`を取得します。

{% download https://drive.google.com/uc?export=view&amp;id=1NedWhPhVuMDTwrHRaFdW-YXZjdH-019yuw %}

## サンプルコード
<pre class="prettyprint"><code>public static Stream&lt;Component&gt; stream(Container parent) {
  return Arrays.stream(parent.getComponents())
    .filter(Container.class::isInstance).map(c -&gt; stream(Container.class.cast(c)))
    .reduce(Stream.of(parent), Stream::concat);
}
//...
stream(chooser)
  .filter(JTable.class::isInstance).map(JTable.class::cast)
  .findFirst()
  .ifPresent(t -&gt; t.setAutoResizeMode(JTable.AUTO_RESIZE_LAST_COLUMN));
</code></pre>

## 解説
上記のサンプルでは、`JFileChooser`の詳細表示で使用されている`JTable`を取得し、その自動サイズ変更モードを変更しています。

- メモ
    - `JPopupMenu`などの子`Component`は取得しない
        - [JFileChooserでの隠しファイルの非表示設定を変更する](http://ateraimemo.com/Swing/FileHidingEnabled.html)
    - `JDK1.8`で導入された`Stream`を使用
        - 以下のように`flatMap`を使用する方法もある
            
            <pre class="prettyprint"><code>public static Stream&lt;Component&gt; stream5(Container parent) {
              return Arrays.stream(parent.getComponents())
                .filter(Container.class::isInstance).map(Container.class::cast)
                .flatMap(c -&gt; Stream.concat(Stream.of(c), stream5(c)));
            }
            public static Stream&lt;Component&gt; stream6(Container parent) {
              return Stream.concat(Stream.of(parent), Arrays.stream(parent.getComponents())
                .filter(Container.class::isInstance).map(Container.class::cast)
                .flatMap(MainPanel::stream6));
            }
</code></pre>
        - 以下のように、`Stream`を使用しない方法もある
            
            <pre class="prettyprint"><code>public static boolean searchAndResizeMode(Container parent) {
              for (Component c: parent.getComponents()) {
                if (c instanceof JTable) {
                  ((JTable) c).setAutoResizeMode(JTable.AUTO_RESIZE_LAST_COLUMN);
                  return true;
                } else if (c instanceof Container &amp;&amp; searchAndResizeMode((Container) c)) {
                  return true;
                }
              }
              return false;
            }
</code></pre>
        - * 参考リンク [#reference]
- [JFileChooserのデフォルトをDetails Viewに設定](http://ateraimemo.com/Swing/DetailsViewFileChooser.html)
- [JFileChooserでの隠しファイルの非表示設定を変更する](http://ateraimemo.com/Swing/FileHidingEnabled.html)
- [Get All Components in a container : Container « Swing JFC « Java](http://www.java2s.com/Code/Java/Swing-JFC/GetAllComponentsinacontainer.htm)

<!-- dummy comment line for breaking list -->

## コメント
