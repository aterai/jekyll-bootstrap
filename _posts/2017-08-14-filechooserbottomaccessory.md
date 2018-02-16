---
layout: post
category: swing
folder: FileChooserBottomAccessory
title: MetalLookAndFeelでJFileChooserの下部にコンポーネントを追加する
tags: [JFileChooser, MetalLookAndFeel]
author: aterai
pubdate: 2017-08-14T15:32:42+09:00
description: MetalLookAndFeelを適用しているJFileChooserのファイルフィルタとボタンパネルの間にJComboBoxのような横長のコンポーネントを追加します。
image: https://drive.google.com/uc?id=1Nyb4wo_ryaaCsJEgpGBxbIlYazx3FQVFfw
hreflang:
    href: https://java-swing-tips.blogspot.com/2017/09/add-jcombobox-that-selects-encoding-at.html
    lang: en
comments: true
---
## 概要
`MetalLookAndFeel`を適用している`JFileChooser`のファイルフィルタとボタンパネルの間に`JComboBox`のような横長のコンポーネントを追加します。

{% download https://drive.google.com/uc?id=1Nyb4wo_ryaaCsJEgpGBxbIlYazx3FQVFfw %}

## サンプルコード
<pre class="prettyprint"><code>class EncodingFileChooserUI extends MetalFileChooserUI {
  public final JComboBox&lt;String&gt; combo = new JComboBox&lt;&gt;(
      new String[] {"UTF-8", "UTF-16", "Shift_JIS", "EUC-JP"});
  protected EncodingFileChooserUI(JFileChooser filechooser) {
    super(filechooser);
  }
  @Override public void installComponents(JFileChooser fc) {
    super.installComponents(fc);
    JPanel bottomPanel = getBottomPanel();

    JLabel label = new JLabel("Encoding:") {
      @Override public Dimension getPreferredSize() {
        return SwingUtils.stream(bottomPanel)
          .filter(JLabel.class::isInstance).map(JLabel.class::cast)
          .findFirst()
          .map(JLabel::getPreferredSize)
          .orElse(super.getPreferredSize());
      }
    };
    label.setDisplayedMnemonic('E');
    label.setLabelFor(combo);

    JPanel panel = new JPanel();
    panel.setLayout(new BoxLayout(panel, BoxLayout.LINE_AXIS));
    panel.add(label);
    panel.add(combo);

    // 0: fileNamePanel
    // 1: RigidArea
    // 2: filesOfTypePanel
    bottomPanel.add(Box.createRigidArea(new Dimension(1, 5)), 3);
    bottomPanel.add(panel, 4);

    SwingUtils.stream(bottomPanel)
      .filter(JLabel.class::isInstance).map(JLabel.class::cast)
      .forEach(l -&gt; {
        l.setHorizontalAlignment(SwingConstants.RIGHT);
        l.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 5));
      });
  }
}
</code></pre>

## 解説
- `JFileChooser#setAccessory(JComponent)`を使用すると`JFileChooser`の右側にコンポーネントが追加されるので、横長のコンポーネントを追加すると`JFileChooser`全体の幅が広がってしまう
    - [JFileChooserに画像プレビューを追加](https://ateraimemo.com/Swing/PreviewAccessory.html)
- `BasicFileChooserUI#getBottomPanel()`メソッドでファイル名入力欄、ファイルフィルタ、ボタンなどを格納している下部パネルを取得し、「ファイルのタイプ(`T`)」パネルとボタンパネルの間に、`JComboBox`のような横長のコンポーネントを設定した別パネルを追加
    - `MetalFileChooserUI`の場合、`2`番目の`filesOfTypePanel`の直後になるよう`bottomPanel.add(Box.createRigidArea(vstrut5), 3); bottomPanel.add(encodingPanel, 4)`で追加
        - [Container#add(Component, int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Container.html#add-java.awt.Component-int-)
    - `BasicFileChooserUI#getBottomPanel()`で取得できる`JPanel`内のレイアウトは、`LookAndFeel`ごとに大きく異なるため同じ方法は使用できない
        - 例えば`WindowsLookAndFeel`では`BoxLayout.LINE_AXIS`、`MetalLookAndFeel`では`BoxLayout.Y_AXIS`
    - `MetalFileChooserUI`では、`JLabel`を継承する`AlignedLabel`で最も長い文字列幅から推奨サイズを揃えているが、`private`のため、このサンプルでは使用できない
        - [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)で、ラベルを検索して推奨サイズを取得しているが、もし`Encoding:`がこの最も長い文字列幅より長い場合は末尾が省略されてしまう
- `JFileChooser#updateUI()`メソッドをオーバーライドして、`super.updateUI(); setUI(new EncodingFileChooserUI(this));`などを実行した場合、`AcceptAll`ファイルフィルタが重複追加されてしまう
    - `setUI(...)`の後で`JFileChooser#resetChoosableFileFilters()`を実行するか、`super.updateUI()`を実行しないことで回避可能
        - 個別のファイルフィルタ追加などの設定は、`JFileChooser#updateUI()`メソッド内でおこなう

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFileChooserに画像プレビューを追加](https://ateraimemo.com/Swing/PreviewAccessory.html)
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)
- [Container#add(Component, int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Container.html#add-java.awt.Component-int-)

<!-- dummy comment line for breaking list -->

## コメント
