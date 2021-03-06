---
layout: post
category: swing
folder: ProgressStringAlignment
title: JProgressBarの進捗文字列の字揃えを変更する
tags: [JProgressBar, JLabel, BorderLayout, Alignment]
author: aterai
pubdate: 2012-04-02T16:48:11+09:00
description: JProgressBarの進捗文字列をJLabelにして、字揃えなどを変更します。
image: https://lh5.googleusercontent.com/-zRMPjXT7do4/T3lYdJUnilI/AAAAAAAABLA/kcpMYSYoklM/s800/ProgressStringAlignment.png
comments: true
---
## 概要
`JProgressBar`の進捗文字列を`JLabel`にして、字揃えなどを変更します。

{% download https://lh5.googleusercontent.com/-zRMPjXT7do4/T3lYdJUnilI/AAAAAAAABLA/kcpMYSYoklM/s800/ProgressStringAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>JProgressBar bar = new JProgressBar(model) {
  private final JLabel label = new JLabel(getString(), halign);
  private final ChangeListener changeListener = new ChangeListener() {
    @Override public void stateChanged(ChangeEvent e) {
      label.setText(getString());
    }
  };
  @Override public void updateUI() {
    removeChangeListener(changeListener);
    removeAll();
    super.updateUI();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        setLayout(new BorderLayout());
        addChangeListener(changeListener);
        add(label);
        label.setBorder(BorderFactory.createEmptyBorder(0, 4, 0, 4));
      }
    });
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JProgressBar`のレイアウトを`BorderLayout`に変更し、水平方向の配置方法を設定した`JLabel`を追加して字揃えを変更しています。

- `JProgressBar#setStringPainted(true)`を同時に使用すると、`2`重に表示される
- 進捗状況に応じた文字色の変化には対応していない
- `NimbusLookAndFeel`の場合で、`TitledBorder`などを直接`JProgressBar`に設定しても、進捗文字列の垂直位置がずれない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JProgressBarの文字列をJLayerを使って表示する](https://ateraimemo.com/Swing/ProgressStringLayer.html)

<!-- dummy comment line for breaking list -->

## コメント
