---
layout: post
category: swing
folder: ScreenResolution
title: ToolkitからScreenResolutionを取得し、コンポーネントで使用するフォントの倍率を変更する
tags: [Toolkit, UIManager, Font, JPanel, JTree, JTable, Fixed]
author: aterai
pubdate: 2015-03-09T09:59:02+09:00
description: ディスプレイの解像度の設定によってパネルの初期サイズ、フォントサイズ、行の高さなどを変更するテストを行います。
image: https://lh3.googleusercontent.com/-Ckc4ZMaD6-8/VPzorX2t8MI/AAAAAAAAN0A/XSE6tpiT92A/s800/ScreenResolution.png
comments: true
---
## 概要
ディスプレイの解像度の設定によってパネルの初期サイズ、フォントサイズ、行の高さなどを変更するテストを行います。

{% download https://lh3.googleusercontent.com/-Ckc4ZMaD6-8/VPzorX2t8MI/AAAAAAAAN0A/XSE6tpiT92A/s800/ScreenResolution.png %}

## サンプルコード
<pre class="prettyprint"><code>private Dimension defaultSize = new Dimension(320, 240);
private Dimension preferredSize;
public static float getSizeOfText() {
  int sr = Toolkit.getDefaultToolkit().getScreenResolution();
  float dpi = System.getProperty("os.name").startsWith("Windows") ? 96f : 72f;
  return sr / dpi;
}
@Override public Dimension getPreferredSize() {
  if (preferredSize == null) {
    float sot = getSizeOfText();
    preferredSize = new Dimension((int) (defaultSize.width * sot),
                                  (int) (defaultSize.height * sot));
  }
  System.out.println(preferredSize);
  return preferredSize;
}
</code></pre>

## 解説
上記のサンプルでは、`Windows`環境で`Smaller-100%`、`Medium-125%`、`Larger-150%`とディスプレイの設定を切り替えて、`ContentPane`のサイズ、`JTable`、`JTree`のフォントサイズや行の高さを変更するテストしています。

- 注: `Java 9`で修正済みで`JDK 1.8.0_102`にもバックポートされているためこのサンプルは無意味だが、解像度の取得方法のメモとして残しておく
- 例: `Medium-125%`の場合
    - `ContentPane`のサイズを`(320 * 1.25, 240 * 1.25)`の`(400, 300)`になるよう、`getPreferredSize()`をオーバーライド
    - [UIManagerで使用するFontを統一](https://ateraimemo.com/Swing/FontChange.html)で、すべてのコンポーネントのフォントサイズを元の`1.25`倍に変更
    - `JTree`の行の高さは、`JTree#isFixedRowHeight()`の場合のみ、元の`1.25`倍に変更
    - `JTable`の行の高さは、`LookAndFeel`依存で一定で、フォントサイズを変更しても追従しないので、`table.setRowHeight( (int) (table.getRowHeight() * getSizeOfText() ) );`として、自前で`1.25`倍に変更
        
        <pre class="prettyprint"><code>JTable table = new JTable(model) {
          @Override public void updateUI() {
            super.updateUI();
            // @see BasicTableUI#installDefaults()
            // JTable's original row height is 16.  To correctly display the
            // contents on Linux we should have set it to 18, Windows 19 and
            // Solaris 20.  As these values vary so much it's too hard to
            // be backward compatable and try to update the row height, we're
            // therefor NOT going to adjust the row height based on font.  If the
            // developer changes the font, it's there responsability to update
            // the row height.
            setRowHeight((int) (getRowHeight() * getSizeOfText()));
          }
        };
</code></pre>
- メモ:
    - `Windows`環境以外ではテストしていない
    - マルチディスプレイ環境で、解像度の異なる画面に移動する場合は考慮していない
    - `Insets`などは変更していない
    - `GraphicsConfiguration#getNormalizingTransform()`などは未調査

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Toolkit#getScreenResolution() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Toolkit.html#getScreenResolution--)
- [UIManagerで使用するFontを統一](https://ateraimemo.com/Swing/FontChange.html)
- [JEP 263: HiDPI Graphics on Windows and Linux](http://openjdk.java.net/jeps/263)
    - [JDK-8055212 JEP 263: HiDPI Graphics on Windows and Linux - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8055212)
    - [JDK-8147440 HiDPI (Windows): Swing components have incorrect sizes after changing display resolution - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8147440)
    - [JDK-8174845 Bad scaling on Windows with large fonts with Java 9ea - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8174845)
    - [JDK-8176883 Enable antialiasing for Metal L&F icons on HiDPI display - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8176883)
- [windows 10 - How do I run Java apps upscaled on a high-DPI display? - Super User](https://superuser.com/questions/988379/how-do-i-run-java-apps-upscaled-on-a-high-dpi-display)

<!-- dummy comment line for breaking list -->

## コメント
