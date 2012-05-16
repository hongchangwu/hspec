module Test.Hspec.FormattersSpec (main, spec) where

import           Test.Hspec.ShouldBe
import           Data.List (isPrefixOf)

import qualified Test.Hspec as H
import qualified Test.Hspec.Internal as H
import           Util

main :: IO ()
main = hspecX spec

spec :: Spec
spec = do
  describe "The `specdoc` Formatter" $ do
    let testSpecs = [H.describe "Example" [
            H.it "success"    (H.Success)
          , H.it "fail 1"     (H.Fail "fail message")
          , H.it "pending"    (H.pending "pending message")
          , H.it "fail 2"     (H.Fail "")
          , H.it "exceptions" (undefined :: H.Result)
          , H.it "fail 3"     (H.Fail "")
          ]
          ]

    it "displays a header for each thing being described" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any (== "Example")

    it "displays one row for each behavior" $ do
      pending

    it "displays a row for each successfull, failed, or pending example" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any (== " - fail 1 FAILED [1]")
      r `shouldSatisfy` any (== " - success")

    it "displays a detailed list of failed examples" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any (== "1) Example fail 1 FAILED")

    it "displays a '#' with an additional message for pending examples" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any (== "     # PENDING: pending message")

    it "summarizes the time it takes to finish" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any ("Finished in " `isPrefixOf`)

    it "summarizes the number of examples and failures" $ do
      r <- runSpec testSpecs
      r `shouldSatisfy` any (== "6 examples, 4 failures")

    it "outputs failed examples in red, pending in yellow, and successful in green" $ do
      pending