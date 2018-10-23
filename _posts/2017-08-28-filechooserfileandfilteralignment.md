---
layout: post
category: swing
folder: FileChooserFileAndFilterAlignment
title: JFileChooserのファイル名とフィルタのラベルを右揃えに変更する
tags: [JFileChooser, JLabel, BoxLayout]
author: aterai
pubdate: 2017-08-28T15:46:15+09:00
description: JFileChooserの下部に表示されるファイル名とフィルタのラベルを左揃えから右揃えに変更します。
image: https://drive.google.com/uc?id=
comments: true
---
## 概要
`JFileChooser`の下部に表示されるファイル名とフィルタのラベルを左揃えから右揃えに変更します。

{% download https://drive.google.com/uc?id=1U4T22tNO7N5NZJUDujh3ZUh68fe-xyvbPw %}

## サンプルコード
<pre class="prettyprint"><code>class RightAlignmentMetalFileChooserUI extends MetalFileChooserUI {
  protected RightAlignmentMetalFileChooserUI(JFileChooser fc) {
    super(fc);
  }
  @Override public void installComponents(JFileChooser fc) {
    super.installComponents(fc);
    SwingUtils.stream(getBottomPanel())
      .filter(JLabel.class::isInstance)
      .map(JLabel.class::cast)
      .forEach(l -&gt; {
        l.setHorizontalAlignment(SwingConstants.RIGHT);
        l.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 5));
      });
  }
}

class RightAlignmentWindowsFileChooserUI extends WindowsFileChooserUI {
  protected RightAlignmentWindowsFileChooserUI(JFileChooser fc) {
    super(fc);
  }
  @Override public void installComponents(JFileChooser fc) {
    super.installComponents(fc);
    SwingUtils.stream(getBottomPanel())
      .filter(JLabel.class::isInstance)
      .map(JLabel.class::cast)
      .forEach(l -&gt; l.setAlignmentX(1f));
  }
}
</code></pre>

## 解説
- `MetalLookAndFeel`
    - `MetalFileChooserUI#getBottomPanel()`で取得できる`JPanel`のレイアウトを`BoxLayout.Y_AXIS`に設定し、以下の`3`つの`JPanel`を縦並びで配置
        - ファイル名ラベルとファイル名入力欄を配置した`fileNamePanel`(`BoxLayout.LINE_AXIS`)
        - ファイルフィルタラベルとファイルフィルタコンボボックスを配置した`filesOfTypePanel`(`BoxLayout.LINE_AXIS`)
        - `approveButton`などを配置した`ButtonPanel`(`FlowLayout`風の独自`ButtonAreaLayout`)
    - 各ラベルの推奨サイズを文字列の長い方に合わせることで、別パネルに分かれていても位置が揃うように設定されているため、`JLabel#setHorizontalAlignment(SwingConstants.RIGHT)`で右揃えに変更可能
- `WindowsLookAndFeel`
    - `WindowsFileChooserUI#getBottomPanel()`で取得できる`JPanel`のレイアウトを`BoxLayout.LINE_AXIS`に設定し、以下の`3`つの`JPanel`を横並びで配置
        - ファイル名ラベルとファイル名入力欄を配置した`fileNamePanel`(`BoxLayout.Y_AXIS`)
        - ファイルフィルタラベルとファイルフィルタコンボボックスを配置した`filesOfTypePanel`(`BoxLayout.Y_AXIS`)
        - `approveButton`などを配置した`ButtonPanel`(`BoxLayout.Y_AXIS`)
    - 各ラベルは`BoxLayout.Y_AXIS`の`JPanel`にまとめられているので、`JComponent.html#setAlignmentX(1f)`で右揃えに変更可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MetalLookAndFeelでJFileChooserの下部にコンポーネントを追加する](https://ateraimemo.com/Swing/FileChooserBottomAccessory.html)
- [Containerの子Componentを再帰的にすべて取得する](https://ateraimemo.com/Swing/GetComponentsRecursively.html)

<!-- dummy comment line for breaking list -->

## コメント
