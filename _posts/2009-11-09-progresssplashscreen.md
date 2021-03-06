---
layout: post
category: swing
folder: ProgressSplashScreen
title: JDialogでモーダルなJProgressBar付きSplash Screenを表示する
tags: [JDialog, JProgressBar, SwingWorker, ModalityType]
author: aterai
pubdate: 2009-11-09T14:54:41+09:00
description: JDialogでモーダルなJProgressBar付きSplash Screenを表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTRSxG9iaI/AAAAAAAAAg8/Wpd3hycacS4/s800/ProgressSplashScreen.png
comments: true
---
## 概要
`JDialog`でモーダルな`JProgressBar`付き`Splash Screen`を表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTRSxG9iaI/AAAAAAAAAg8/Wpd3hycacS4/s800/ProgressSplashScreen.png %}

## サンプルコード
<pre class="prettyprint"><code>final JFrame frame = new JFrame("@title@");
final JDialog splashScreen = new JDialog(
    frame, Dialog.ModalityType.DOCUMENT_MODAL);
final JProgressBar progress = new JProgressBar();
System.out.println(splashScreen.getModalityType());
EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    splashScreen.setUndecorated(true);
    splashScreen.getContentPane().add(
        new JLabel(new ImageIcon(getClass().getResource("splash.png"))));
    splashScreen.getContentPane().add(progress, BorderLayout.SOUTH);
    splashScreen.pack();
    splashScreen.setLocationRelativeTo(null);
    splashScreen.setVisible(true);
  }
});
SwingWorker&lt;Void, Void&gt; worker = new SwingWorker&lt;Void, Void&gt;() {
  @Override public Void doInBackground() {
    try {
      int current = 0;
      int lengthOfTask = 120;
      while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
        try {
          Thread.sleep(50);
        } catch (InterruptedException ie) {
          ie.printStackTrace();
          return null;
        }
        setProgress(100 * current++ / lengthOfTask);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  @Override public void done() {
    splashScreen.dispose();
  }
};
worker.addPropertyChangeListener(new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    if ("progress".equals(e.getPropertyName())) {
      progress.setValue((Integer) e.getNewValue());
    }
  }
});
worker.execute();
frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
frame.getContentPane().add(new MainPanel());
frame.pack();
frame.setLocationRelativeTo(null);
EventQueue.invokeLater(new Runnable() {
  @Override public void run() {
    frame.setVisible(true);
  }
});
</code></pre>

## 解説
上記のサンプルでは、以下のようなスプラッシュスクリーンを作成して表示しています。

- モーダルな`JDialog`に画像と`JProgressBar`を追加
- `Dialog#setUndecorated(true)`としてタイトルバーを非表示
- `SwingWorker`を使って進捗状態を表示

<!-- dummy comment line for breaking list -->

- - - -
- `JTabbedPane`にタブを順次追加する`SwingWorker`のテスト

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.beans.*;
import java.util.List;
import javax.swing.*;

public class ProgressSplashScreenTest {
  public static void main(String[] args) {
    EventQueue.invokeLater(() -&gt; {
      createAndShowGUI();
    });
  }
  public static void createAndShowGUI() {
    JFrame frame = new JFrame();
    JDialog splashScreen  = new JDialog(
      frame, Dialog.ModalityType.DOCUMENT_MODAL);
    JProgressBar progress = new JProgressBar();
    JTabbedPane tabbedPane = new JTabbedPane();
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(tabbedPane);
    progress.setStringPainted(true);

    EventQueue.invokeLater(() -&gt; {
      splashScreen.setUndecorated(true);
      splashScreen.getContentPane().add(
          new JLabel(new SplashScreenIcon()));
      splashScreen.getContentPane().add(progress, BorderLayout.SOUTH);
      splashScreen.pack();
      splashScreen.setLocationRelativeTo(null);
      splashScreen.setVisible(true);
    });

    SwingWorker&lt;Void, String&gt; worker = new SwingWorker&lt;Void, String&gt;() {
      @Override public Void doInBackground() {
        try {
          int current = 0;
          int lengthOfTask = 120;
          while (current &lt;= lengthOfTask &amp;&amp; !isCancelled()) {
            try {
              Thread.sleep(50); //dummy
            } catch (InterruptedException ie) {
              ie.printStackTrace();
              return null;
            }
            if (current == 20) {
              publish("showFrame");
            } else if (current % 24 == 0) {
              publish("title: " + current);
            }
            setProgress(100 * current++ / lengthOfTask);
          }
        } catch (Exception ex) {
          ex.printStackTrace();
        }
        return null;
      }

      @Override protected void process(List&lt;String&gt; chunks) {
        for (String cmd: chunks) {
          if (cmd.equals("showFrame")) {
            frame.setSize(512, 320);
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
          } else {
            tabbedPane.addTab(cmd, new JLabel(cmd));
            tabbedPane.setSelectedIndex(tabbedPane.getTabCount() - 1);
            progress.setString("Loading: " + cmd);
          }
        }
      }

      @Override public void done() {
        splashScreen.dispose();
      }
    };
    worker.addPropertyChangeListener(e -&gt; {
      if ("progress".equals(e.getPropertyName())) {
        progress.setValue((Integer) e.getNewValue());
      }
    });
    worker.execute();
  }
}
class SplashScreenIcon implements Icon {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.translate(x, y);
    g2.setPaint(Color.GREEN);
    g2.fillRect(10, 10, 180, 80);
    g2.translate(-x, -y);
    g2.dispose();
  }

  @Override public int getIconWidth()  {
    return 200;
  }

  @Override public int getIconHeight() {
    return 100;
  }
}
</code></pre>

## 参考リンク
- [JWindowを使ったSplash Screenの表示](https://ateraimemo.com/Swing/SplashScreen.html)

<!-- dummy comment line for breaking list -->

## コメント
